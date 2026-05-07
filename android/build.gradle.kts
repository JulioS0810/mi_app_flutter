// ----------------------------------------------------------------------------
// Archivo: android/build.gradle.kts (Nivel de Proyecto)
// Proyecto: mi_app - Perfumería Violeta (ADSO SENA)
// Descripción: Configuración global de Gradle para Android.
//              Define los repositorios, las dependencias de herramientas
//              (buildscript) y los complementos necesarios para compilar
//              la aplicación con Flutter, Firebase y Kotlin.
// ----------------------------------------------------------------------------

// ============================================================================
// 1. SCRIPT DE CONSTRUCCIÓN (BUILDSCRIPT)
// ============================================================================
// Este bloque se ejecuta primero y configura el classpath de Gradle,
// es decir, las herramientas necesarias para compilar el proyecto.
buildscript {
    // Repositorios desde donde Gradle descargará las dependencias del classpath
    repositories {
        google()          // SDK de Android, Firebase, etc.
        mavenCentral()    // Muchas bibliotecas Kotlin y Java
    }

    dependencies {
        // Plugin de Android Gradle (AGP) – necesario para compilar cualquier proyecto Android
        // Versión 8.7.2 estable y compatible con Flutter y con Gradle 8.7–8.9
        classpath("com.android.tools.build:gradle:8.7.2")

        // Plugin de Google Services – necesario para el archivo google-services.json de Firebase
        // Versión 4.4.2 estable y soportada por Firebase Core y Firestore
        classpath("com.google.gms:google-services:4.4.2")

        // Plugin de Kotlin – necesario para los módulos que usan Kotlin (por defecto en proyectos Flutter)
        // Versión 1.9.22 compatible con AGP 8.7.2 y Gradle 8.7+
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.22")
    }
}

// ============================================================================
// 2. CONFIGURACIÓN DE REPOSITORIOS PARA TODOS LOS SUBPROYECTOS
// ============================================================================
// Los submódulos del proyecto (como ":app") también necesitan acceder google() y mavenCentral()
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ============================================================================
// 3. REDIRECCIÓN DEL DIRECTORIO DE CONSTRUCCIÓN (BUILD)
// ============================================================================
// Por defecto, Gradle genera la carpeta "build" dentro de "android/".
// Esta configuración la mueve a la raíz del proyecto Flutter (../../build)
// para centralizar todos los archivos generados y facilitar la limpieza.
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Aplica la misma redirección a cada submódulo (por ejemplo, ":app").
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// ============================================================================
// 4. DEPENDENCIA DE EVALUACIÓN (PARA EL MÓDULO ":app")
// ============================================================================
// Indica que el proyecto raíz depende de que el submódulo ":app" se evalúe primero.
// Esto evita errores en tiempo de configuración de Gradle.
subprojects {
    project.evaluationDependsOn(":app")
}

// ============================================================================
// 5. TAREA DE LIMPIEZA PERSONALIZADA ("CLEAN")
// ============================================================================
// Al ejecutar "flutter clean" o "./gradlew clean", se elimina el directorio
// de construcción raíz (el que hemos redirigido, es decir, "../../build").
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
