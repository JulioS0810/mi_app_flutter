// ----------------------------------------------------------------------------
// Archivo: android/app/build.gradle.kts (Nivel de Módulo)
// Proyecto: mi_app - Perfumería Violeta (ADSO SENA)
// Descripción: Configuración específica de la aplicación Android.
//              Define el espacio de nombres, las versiones del SDK,
//              las opciones de compilación, tipos de build y la firma.
//              Se aplica el plugin de Google Services para Firebase.
// ----------------------------------------------------------------------------

// ============================================================================
// 1. PLUGINS DEL MÓDULO
// ============================================================================
plugins {
    // Plugin obligatorio para aplicaciones Android (aplica tareas como assemble, install, etc.)
    id("com.android.application")

    // Plugin de Kotlin para Android (necesario para los plugins nativos de Flutter)
    id("kotlin-android")

    // Plugin oficial de Flutter para integración con Gradle
    // Debe aplicarse después de los plugins de Android y Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

// ============================================================================
// 2. CONFIGURACIÓN DEL SDK DE ANDROID
// ============================================================================
android {
    // Identificador único del paquete de la aplicación
    // Debe coincidir con el package_name definido en google-services.json
    namespace = "com.example.mi_app"

    // Versión del SDK de compilación (usamos la que Flutter determina automáticamente)
    compileSdk = flutter.compileSdkVersion

    // Versión del NDK (Native Development Kit) usada por Flutter
    ndkVersion = flutter.ndkVersion

    // Opciones de compatibilidad del código Java/Kotlin
    compileOptions {
        // Fuente y target compatibles con Java 17 (requerido por versiones modernas de AGP)
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        // Especifica la versión de JVM para el código compilado de Kotlin
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    // ------------------------------------------------------------------------
    // CONFIGURACIÓN POR DEFECTO (defaultConfig)
    // ------------------------------------------------------------------------
    defaultConfig {
        // ID de la aplicación (debe coincidir con el namespace o ser diferente,
        // pero lo habitual es que sea el mismo)
        applicationId = "com.example.mi_app"

        // Versión mínima de Android soportada (la que Flutter determine)
        minSdk = flutter.minSdkVersion

        // Versión objetivo del SDK (la que Flutter determine)
        targetSdk = flutter.targetSdkVersion

        // Código de versión interna (para Google Play y actualizaciones)
        versionCode = flutter.versionCode

        // Nombre de versión visible para el usuario
        versionName = flutter.versionName
    }

    // ------------------------------------------------------------------------
    // TIPOS DE CONSTRUCCIÓN (buildTypes)
    // ------------------------------------------------------------------------
    buildTypes {
        // Configuración para la versión de lanzamiento (release)
        release {
            // Por defecto, usa la configuración de firma de depuración (debug)
            // Esto permite ejecutar `flutter run --release` sin necesidad de un keystore propio.
            // Para publicar en Google Play, debes crear tu propio keystore y configurarlo aquí.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

// ============================================================================
// 3. CONFIGURACIÓN DEL PLUGIN DE FLUTTER
// ============================================================================
flutter {
    // Ruta donde se encuentra el directorio raíz de Flutter (el proyecto principal)
    // Como este archivo está en android/app/, la raíz está dos niveles arriba.
    source = "../.."
}

// ============================================================================
// 4. APLICACIÓN DEL PLUGIN DE GOOGLE SERVICES (FIREBASE)
// ============================================================================
// Este plugin lee el archivo google-services.json (ubicado en android/app/)
// y configura automáticamente las dependencias necesarias para Firebase.
// Debe ir al final del archivo, después de cualquier configuración de android.
apply(plugin = "com.google.gms.google-services")
