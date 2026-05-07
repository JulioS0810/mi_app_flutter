// ----------------------------------------------------------------------------
// PROYECTO: mi_app - Plataforma Web/Móvil
// ARCHIVO: main.dart (Optimizado con manejo de errores y carga)
// DESARROLLADOR: Julio César Suárez Garavito (Aprendiz ADSO)
// INSTRUCTORA: Elizabeth Gelves Gelves
// DESCRIPCIÓN: Punto de entrada principal, inicializa Firebase y lanza la app.
// ----------------------------------------------------------------------------

library;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home_screen.dart';

/// --------------------------------------------------------------------------
/// 1. PUNTO DE ENTRADA PRINCIPAL
/// --------------------------------------------------------------------------
/// La función main es asíncrona porque necesita inicializar Firebase antes de
/// mostrar cualquier interfaz. Se manejan posibles errores de conexión.
void main() async {
  try {
    // Asegura que los bindings de Flutter estén listos para usar plugins nativos.
    WidgetsFlutterBinding.ensureInitialized();

    // Inicializa Firebase usando la configuración específica de la plataforma
    // (Android, iOS, Web, etc.) generada automáticamente por flutterfire configure.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Si la inicialización falla (ej: sin conexión a internet), se muestra un error.
    // En producción, podrías registrar este error con un servicio de analytics.
    debugPrint('❌ Error al inicializar Firebase: $e');
  }

  // Una vez que Firebase está listo (o si falló), se lanza la aplicación.
  runApp(const MyApp());
}

/// --------------------------------------------------------------------------
/// 2. WIDGET PRINCIPAL (RAÍZ) DE LA APLICACIÓN
/// --------------------------------------------------------------------------
/// MyApp es un StatelessWidget que define la configuración global: tema, rutas
/// y la pantalla inicial. Se recomienda mantenerlo liviano y sin lógica de negocio.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Elimina la etiqueta "DEBUG" en la esquina superior derecha.
      debugShowCheckedModeBanner: false,

      // Título de la aplicación (visible en ventanas, administradores de tareas, etc.)
      title: 'mi_app - Gestión Cloud', // CORREGIDO: Nombre correcto del proyecto

      // Define la paleta de colores principal usando un esquema generado a partir
      // de un color semilla (deepPurple). El parámetro 'brightness' asegura buen contraste.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        // Habilita Material Design 3, el estándar más moderno de Google.
        useMaterial3: true,
      ),

      // Pantalla inicial de la aplicación (HomeScreen con isTest=false por defecto).
      home: const HomeScreen(),
    );
  }
}
