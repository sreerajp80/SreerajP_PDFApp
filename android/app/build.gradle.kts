import java.io.File
import java.io.FileInputStream
import java.time.LocalDate
import java.util.Properties
import org.gradle.api.GradleException

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

val generateBuildMetadata = tasks.register("generateBuildMetadata") {
    group = "build setup"
    description = "Generates About-screen build metadata before Android builds."

    inputs.file(projectRootDir.resolve("pubspec.yaml"))
    inputs.file(projectRootDir.resolve("tool/generate_app_version.dart"))
    inputs.file(projectRootDir.resolve("tool/generate_build_date.dart"))
    inputs.property("metadataBuildDate", LocalDate.now().toString())
    outputs.file(projectRootDir.resolve("lib/core/constants/app_version.g.dart"))
    outputs.file(projectRootDir.resolve("lib/core/constants/build_date.g.dart"))

    doLast {
        if (!dartExecutable.exists()) {
            throw GradleException(
                "Could not find Dart executable at ${dartExecutable.absolutePath}. " +
                    "Check android\\local.properties flutter.sdk or FLUTTER_ROOT."
            )
        }

        project.exec {
            workingDir = projectRootDir
            commandLine(dartExecutable.absolutePath, "run", "tool/generate_app_version.dart")
        }
        project.exec {
            workingDir = projectRootDir
            commandLine(dartExecutable.absolutePath, "run", "tool/generate_build_date.dart")
        }
    }
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

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
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
            manifestPlaceholders["appLabel"] = "SreerajP PDF App Dev"
        }
        create("prod") {
            dimension = "environment"
            manifestPlaceholders["appLabel"] = "SreerajP PDF App"
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
