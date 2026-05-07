// ----------------------------------------------------------------------------
// PROYECTO: mi_app - Plataforma Web/Móvil
// ARCHIVO: item.dart
// DESARROLLADOR: Julio César Suárez Garavito (Aprendiz ADSO)
// INSTRUCTORA: Elizabeth Gelves Gelves
// DESCRIPCIÓN: Modelo de datos para la colección 'personas' en Cloud Firestore.
//              Define la estructura de una persona (Item) y sus métodos de
//              serialización (toMap / fromMap). Incluye el campo 'fecha_registro'
//              para ordenamiento cronológico.
// ----------------------------------------------------------------------------

import 'package:cloud_firestore/cloud_firestore.dart';

// ============================================================================
// CLASE MODELO: Item
// ============================================================================

/// Representa una entidad 'Persona' dentro del sistema de la Perfumería Violeta.
/// Los objetos de esta clase se utilizan para interactuar con la colección
/// 'personas' de Firestore, permitiendo la conversión entre documentos
/// Firestore y objetos Dart.
class Item {
  // --------------------------------------------------------------------------
  // ATRIBUTOS
  // --------------------------------------------------------------------------

  /// Identificador único del documento en Firestore.
  /// Se asigna automáticamente al agregar un documento a la colección.
  final String id; // id del documento lo asigna Firestore (no se guarda como campo, solo para referencia)
  /// Nombre completo del usuario.
  final String nombre; // Nombre completo del usuario (mapeado desde el campo nombre del formulario).

  /// Profesión o rol (mapeado desde el campo descripción del formulario).
  final String descripcion; // Profesión o rol del usuario (mapeado desde el campo descripción del formulario).

  // --------------------------------------------------------------------------
  // CONSTRUCTOR
  // --------------------------------------------------------------------------

  /// Constructor principal. Requiere todos los parámetros obligatorios.
  Item({
    required this.id,
    required this.nombre,
    required this.descripcion,
  }); // Fin del constructor Item

  // --------------------------------------------------------------------------
  // MÉTODOS DE SERIALIZACIÓN
  // --------------------------------------------------------------------------

  /// Convierte un documento de Firestore (mapa + id) en un objeto [Item].
  ///
  /// [id]: Identificador del documento.
  /// [data]: Mapa con los campos del documento (nombre, descripcion, etc.).
  ///
  /// Se utiliza `as String?` para garantizar null safety y se proporciona
  /// un valor por defecto ('') en caso de que el campo no exista.
  factory Item.fromMap(String id, Map<String, dynamic> data) {
    return Item(
      id: id,
      nombre: data['nombre'] as String? ?? '',
      descripcion: data['descripcion'] as String? ?? '',
    );
  } // Fin de factory fromMap

  /// Convierte el objeto [Item] en un mapa apto para ser guardado en Firestore.
  ///
  /// El campo 'fecha_registro' utiliza [FieldValue.serverTimestamp()] para
  /// que Firestore asigne la fecha/hora exacta del servidor, garantizando
  /// orden cronológico confiable en cualquier zona horaria.
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'fecha_registro': FieldValue.serverTimestamp(), // Timestamp del servidor
    };
  } // Fin de toMap
} // Fin de la clase Item
