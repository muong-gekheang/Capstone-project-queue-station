// plugins {
//     id("com.android.application")
//     // START: FlutterFire Configuration
//     id("com.google.gms.google-services")
//     // END: FlutterFire Configuration
//     id("kotlin-android")
//     // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
//     id("dev.flutter.flutter-gradle-plugin")
// }
// import java.util.Properties
// val localProperties = java.util.Properties()
// val localPropertiesFile = rootProject.file("local.properties")
// if (localPropertiesFile.exists()) {
//     localPropertiesFile.inputStream().use { localProperties.load(it) }
// }

// android {
//     namespace = "com.example.queue_station_app"
//     compileSdk = flutter.compileSdkVersion
//     ndkVersion = flutter.ndkVersion

//     compileOptions {
//         sourceCompatibility = JavaVersion.VERSION_17
//         targetCompatibility = JavaVersion.VERSION_17
//     }

//     // kotlinOptions {
//     //     jvmTarget = JavaVersion.VERSION_17.toString()
//     // }

//     kotlinOptions {
//         jvmTarget = "17"
//     }

//     defaultConfig {
//         // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
//         applicationId = "com.example.queue_station_app"
//         // You can update the following values to match your application needs.
//         // For more information, see: https://flutter.dev/to/review-gradle-config.
//         minSdk = flutter.minSdkVersion
//         targetSdk = flutter.targetSdkVersion
//         versionCode = flutter.versionCode
//         versionName = flutter.versionName

//         // --- ADD THIS LINE ---
//         manifestPlaceholders += mapOf("MAPS_API_KEY" to (localProperties.getProperty("MAPS_API_KEY") ?: ""))
//     }

//     buildTypes {
//         release {
//             // TODO: Add your own signing config for the release build.
//             // Signing with the debug keys for now, so `flutter run --release` works.
//             signingConfig = signingConfigs.getByName("debug")
//         }
//     }
// }

// flutter {
//     source = "../.."
// }
import java.util.Properties

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { localProperties.load(it) }
}

android {
    namespace = "com.example.queue_station_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

        // ADD THIS
    useLibrary("org.apache.http.legacy")

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.queue_station_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        manifestPlaceholders += mapOf("MAPS_API_KEY" to (localProperties.getProperty("MAPS_API_KEY") ?: ""))
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