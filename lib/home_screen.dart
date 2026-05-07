// ----------------------------------------------------------------------------
// PROYECTO: mi_app - Plataforma Web/Móvil
// ARCHIVO: home_screen.dart
// DESARROLLADOR: Julio César Suárez Garavito (Aprendiz ADSO)
// INSTRUCTORA: Elizabeth Gelves Gelves
// DESCRIPCIÓN: Pantalla principal que integra un formulario de registro y una
//              lista en tiempo real de personas almacenadas en Cloud Firestore.
//              Incluye soporte para pruebas unitarias mediante el flag [isTest].
//              El modelo de datos [Item] se importa desde 'item.dart'.
// ----------------------------------------------------------------------------

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_app/item.dart';          // Modelo de datos (clase Item)
import 'dart:developer' as developer;       // Logs profesionales para depuración

// ============================================================================
// WIDGET PRINCIPAL: HomeScreen
// ============================================================================

/// Pantalla principal de la aplicación. Muestra un formulario (nombre y
/// descripción), un botón para guardar y una lista en tiempo real de los
/// registros existentes en Firestore.
///
/// El parámetro [isTest] deshabilita toda interacción con Firebase durante
/// las pruebas unitarias, evitando llamadas reales a la nube.
class HomeScreen extends StatefulWidget {
  final bool isTest;

  const HomeScreen({super.key, this.isTest = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
} // Fin de la clase HomeScreen

// ============================================================================
// ESTADO DE HomeScreen
// ============================================================================

class _HomeScreenState extends State<HomeScreen> {
  // Controladores de texto para capturar la entrada del usuario
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();

  // Referencia a la colección 'personas' de Firestore (solo se usa si no es test)
  CollectionReference? _personasCollection;

  // --------------------------------------------------------------------------
  // INIT STATE
  // --------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    if (!widget.isTest) {
      _personasCollection = FirebaseFirestore.instance.collection('personas');
    }
  } // Fin de initState

  // --------------------------------------------------------------------------
  // GUARDAR ITEM
  // --------------------------------------------------------------------------
  Future<void> _guardarItem() async {
    final nombre = _nombreController.text.trim();
    final descripcion = _descripcionController.text.trim();

    if (nombre.isEmpty) return;

    FocusScope.of(context).unfocus();
    _nombreController.clear();
    _descripcionController.clear();

    if (widget.isTest) {
      developer.log(
        'ENTORNO TEST: Guardado simulado de $nombre',
        name: 'SENA.ADSO',
      );
      return;
    }

    final nuevoItem = Item(
      id: '',
      nombre: nombre,
      descripcion: descripcion,
    );

    try {
      await _personasCollection!.add(nuevoItem.toMap());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Registro exitoso'),
          backgroundColor: Colors.deepPurple,
        ),
      );
    } catch (e) {
      developer.log('Error al guardar: $e', name: 'SENA.ADSO.Error');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } // Fin de _guardarItem

  // --------------------------------------------------------------------------
  // CONSTRUIR LISTA REACTIVA
  // --------------------------------------------------------------------------
  Widget _buildStreamList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _personasCollection!.snapshots(), // Sin orderBy para evitar errores
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('⚠️ Error de conexión con la base de datos'),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            final item = Item.fromMap(docs[index].id, data);

            return ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.deepPurple),
              title: Text(
                item.nombre,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item.descripcion),
            );
          },
        );
      },
    );
  } // Fin de _buildStreamList

  // --------------------------------------------------------------------------
  // BUILD
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Registro de Items',
          style: TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _guardarItem,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF5F0FF),
                foregroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: widget.isTest
                  ? const Center(
                      child: Text('🔒 Modo Test: Listado Deshabilitado'),
                    )
                  : _buildStreamList(),
            ),
          ],
        ),
      ),
    );
  } // Fin de build

  // --------------------------------------------------------------------------
  // DISPOSE
  // --------------------------------------------------------------------------
  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    super.dispose();
  } // Fin de dispose
} // Fin de _HomeScreenState
