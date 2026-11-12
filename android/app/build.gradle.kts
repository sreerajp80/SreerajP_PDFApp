import java.io.File
import java.io.FileInputStream
import java.time.LocalDate
import java.util.Properties
import javax.inject.Inject
import org.gradle.api.GradleException
import org.gradle.process.ExecOperations
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    FileInputStream(localPropertiesFile).use(localProperties::load)
}

val flutterSdkPath = localProperties.getProperty("flutter.sdk")
    ?: System.getenv("FLUTTER_ROOT")
    ?: throw GradleException(
        "Flutter SDK path not found. Set flutter.sdk in android\\local.properties or FLUTTER_ROOT."
    )

val isWindowsHost = System.getProperty("os.name").startsWith("Windows", ignoreCase = true)
val dartExecutable = File(
    flutterSdkPath,
    if (isWindowsHost) "bin\\dart.bat" else "bin/dart",
)
val projectRootDir = rootProject.projectDir.parentFile

// Runs the Dart scripts that write the About-screen version and build date.
// Gradle 9 removed `project.exec { }`, so the task gets an injected `ExecOperations`
// instead (flavors guide, "Android Toolchain Baseline"). This also works on Gradle 8.
abstract class GenerateBuildMetadataTask : DefaultTask() {
    @get:Inject
    abstract val execOperations: ExecOperations

    @get:Internal
    abstract val dartExecutablePath: Property<String>

    @get:Internal
    abstract val workingDirectory: DirectoryProperty

    @TaskAction
    fun generate() {
        val dart = File(dartExecutablePath.get())
        if (!dart.exists()) {
            throw GradleException(
                "Could not find Dart executable at ${dart.absolutePath}. " +
                    "Check android\\local.properties flutter.sdk or FLUTTER_ROOT."
            )
        }
        val rootDir = workingDirectory.get().asFile
        for (script in listOf("tool/generate_app_version.dart", "tool/generate_build_date.dart")) {
            execOperations.exec {
                workingDir = rootDir
                commandLine(dart.absolutePath, "run", script)
            }
        }
    }
}

val generateBuildMetadata = tasks.register<GenerateBuildMetadataTask>("generateBuildMetadata") {
    group = "build setup"
    description = "Generates About-screen build metadata before Android builds."

    dartExecutablePath.set(dartExecutable.absolutePath)
    workingDirectory.set(projectRootDir)

    inputs.file(projectRootDir.resolve("pubspec.yaml"))
    inputs.file(projectRootDir.resolve("tool/generate_app_version.dart"))
    inputs.file(projectRootDir.resolve("tool/generate_build_date.dart"))
    inputs.property("metadataBuildDate", LocalDate.now().toString())
    outputs.file(projectRootDir.resolve("lib/core/constants/app_version.g.dart"))
    outputs.file(projectRootDir.resolve("lib/core/constants/build_date.g.dart"))
}

tasks.named("preBuild") {
    dependsOn(generateBuildMetadata)
}

tasks.matching { task ->
    task.name.startsWith("compileFlutterBuild")
}.configureEach {
    dependsOn(generateBuildMetadata)
}

android {
    namespace = "in.sreerajp.pdfapp"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "in.sreerajp.pdfapp"
        // minSdk 26 (Android 8.0) is a hard project rule — do not lower it.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // dev / prod flavors (engineering standard §5.2, §5.3). The Flutter tool auto-injects
    // FLUTTER_APP_FLAVOR from --flavor; the Dart AppFlavorConfig reads it.
    flavorDimensions += "environment"
    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
        }
        create("prod") {
            dimension = "environment"
        }
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                val props = Properties()
                props.load(keystorePropertiesFile.inputStream())
                keyAlias      = props.getProperty("keyAlias")
                keyPassword   = props.getProperty("keyPassword")
                storeFile     = file(props.getProperty("storeFile"))
                storePassword = props.getProperty("storePassword")
            }
        }
    }

    buildTypes {
        release {
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                signingConfig = signingConfigs.getByName("debug")
            }
        }
    }

    // Keep every language on the device: the in-app language picker can switch to
    // a language the Play Store would otherwise leave out (engineering standard §8.1).
    bundle {
        language {
            enableSplit = false
        }
    }
}

// Kotlin compiler options (engineering standard §5.3: `compilerOptions`, not `kotlinOptions`).
kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

flutter {
    source = "../.."
}

dependencies {
    // PdfBox-Android (Apache 2.0) — reads PDF metadata now; page ops / extraction in later
    // phases. Open-source rule: Apache 2.0 is fine. Rendering stays with pdfrx (pdfium).
    implementation("com.tom-roush:pdfbox-android:2.0.27.0")

    // Bouncy Castle (MIT) — PKCS#7 / CMS signature verification (Phase 7).
    //
    // PdfBox already pulls these in transitively; they are declared here because we now use
    // them directly, and an explicit version cannot drift out from under us. Keep the version
    // matched to PdfBox's own to avoid two copies on the classpath.
    //
    // The `jdk15to18` variant is the Android-targeted build. Android ships its own stripped
    // Bouncy Castle, but it has long been repackaged under `com.android.org.bouncycastle`, so
    // on minSdk 26 there is no class clash with `org.bouncycastle` — the old Spongy Castle
    // workaround is not needed. The one live gotcha: get the provider by *instance*, never by
    // the name "BC", which resolves to Android's stripped copy (see SignatureHandler).
    implementation("org.bouncycastle:bcprov-jdk15to18:1.72")
    implementation("org.bouncycastle:bcpkix-jdk15to18:1.72")
}

// Block prod --release tasks at execution time when key.properties is absent.
afterEvaluate {
    listOf("assembleProdRelease", "bundleProdRelease").forEach { taskName ->
        tasks.findByName(taskName)?.doFirst {
            if (!keystorePropertiesFile.exists()) {
                throw org.gradle.api.GradleException(
                    "\n" +
                    "══════════════════════════════════════════════════════════\n" +
                    "  SIGNING REQUIRED — prod --release build blocked         \n" +
                    "══════════════════════════════════════════════════════════\n" +
                    "  android/key.properties not found.                       \n" +
                    "  Create the file with your release keystore credentials. \n" +
                    "  See docs/release_process.md                             \n" +
                    "  Section: Android Signing Configuration                  \n" +
                    "══════════════════════════════════════════════════════════\n"
                )
            }
        }
    }
}
