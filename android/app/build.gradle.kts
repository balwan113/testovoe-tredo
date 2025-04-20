import org.gradle.api.JavaVersion

plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Плагин для Firebase
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.flutter_testovoe_tredo"
    compileSdk = 33  // Используем актуальную версию SDK
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true // ✅ Kotlin-стиль
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.flutter_testovoe_tredo"
        minSdk = 23
        targetSdk = 33  // Используем актуальную версию SDK
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:33.12.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-messaging:23.1.1") // Добавлена зависимость для Firebase Cloud Messaging

    // Core desugaring lib (чтобы coreLibraryDesugaringEnabled работал)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
