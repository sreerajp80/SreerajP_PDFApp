plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
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
            manifestPlaceholders["appLabel"] = "PDF App Dev"
        }
        create("prod") {
            dimension = "environment"
            manifestPlaceholders["appLabel"] = "PDF App"
        }
    }

    buildTypes {
        release {
            // TODO: Real release signing config is added in Phase 8 (release_process / guideline §2).
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
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
}
