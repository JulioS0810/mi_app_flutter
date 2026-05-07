// ----------------------------------------------------------------------------
// PROYECTO: mi_app - Plataforma Web/Móvil
// ARCHIVO: widget_test.dart
// DESARROLLADOR: Julio César Suárez Garavito (Aprendiz ADSO)
// INSTRUCTORA: Elizabeth Gelves Gelves
// DESCRIPCIÓN: Prueba de widget optimizada para validar la interfaz de HomeScreen.
//              Utiliza el modo [isTest] para evitar conflictos con Firebase
//              y verifica la presencia de elementos, entrada de datos y botones.
// ----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_app/home_screen.dart'; // Importación de la pantalla principal

void main() {
  // Inicializa los bindings de Flutter necesarios para ejecutar pruebas de widgets.
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Prueba: Validación de Interfaz - Registro de Items', (WidgetTester tester) async {
    
    // ----------------------------------------------------------------------
    // 1. CONSTRUCCIÓN DEL WIDGET (CONFIGURACIÓN DEL ENTORNO)
    // ----------------------------------------------------------------------
    // Inflamos el widget HomeScreen. 
    // IMPORTANTE: Se activa 'isTest: true' para deshabilitar Firebase en esta prueba.
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(isTest: true),
      ),
    );

    // Esperamos a que todas las animaciones y renderizados iniciales terminen.
    await tester.pumpAndSettle();

    // ----------------------------------------------------------------------
    // 2. VERIFICACIÓN DE COMPONENTES VISUALES (ESTADO INICIAL)
    // ----------------------------------------------------------------------

    // 2.1 Verificar título de la AppBar
    // Se sincronizó con home_screen.dart: "Registro de Items"
    expect(find.text('Registro de Items'), findsOneWidget);

    // 2.2 Verificar campos de texto por su etiqueta (LabelText)
    expect(find.widgetWithText(TextField, 'Nombre'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Descripción'), findsOneWidget);

    // 2.3 Verificar botón de acción
    expect(find.widgetWithText(ElevatedButton, 'Guardar'), findsOneWidget);

    // ----------------------------------------------------------------------
    // 3. SIMULACIÓN DE INTERACCIÓN DEL USUARIO
    // ----------------------------------------------------------------------

    // 3.1 Simular escritura en el campo "Nombre" (Índice 0)
    await tester.enterText(find.byType(TextField).at(0), 'Julio Suarez');
    
    // 3.2 Simular escritura en el campo "Descripción" (Índice 1)
    await tester.enterText(find.byType(TextField).at(1), 'Aprendiz ADSO - SENA');

    // Procesamos el cambio de estado en la interfaz tras la escritura
    await tester.pump();

    // 3.3 Validar que el texto ingresado es visible en pantalla
    expect(find.text('Julio Suarez'), findsOneWidget);
    expect(find.text('Aprendiz ADSO - SENA'), findsOneWidget);

    // ----------------------------------------------------------------------
    // 4. PRUEBA DE FUNCIONALIDAD DEL BOTÓN
    // ----------------------------------------------------------------------
    
    // Ejecutamos el tap en el botón Guardar
    await tester.tap(find.widgetWithText(ElevatedButton, 'Guardar'));

    // pumpAndSettle es vital aquí para esperar que la función _guardarItem() 
    // termine su ejecución lógica y limpie los controladores.
    await tester.pumpAndSettle();

    // 4.1 Verificación post-guardado: Los campos deben estar vacíos nuevamente
    expect(find.text('Julio Suarez'), findsNothing);
    expect(find.text('Aprendiz ADSO - SENA'), findsNothing);

    // La prueba finaliza con éxito si se llega a este punto.
  });
}
