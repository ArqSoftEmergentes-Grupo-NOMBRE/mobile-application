import 'package:equatable/equatable.dart';

enum DeliverableStatus { PENDIENTE, ENTREGADO, APROBADO }

extension DeliverableStatusX on DeliverableStatus {
  static DeliverableStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'ENTREGADO':
        return DeliverableStatus.ENTREGADO;
      case 'APROBADO':
        return DeliverableStatus.APROBADO;
      case 'PENDIENTE':
      default:
        return DeliverableStatus.PENDIENTE;
    }
  }

  String get backendValue {
    switch (this) {
      case DeliverableStatus.ENTREGADO:
        return 'ENTREGADO';
      case DeliverableStatus.APROBADO:
        return 'APROBADO';
      case DeliverableStatus.PENDIENTE:
      default:
        return 'PENDIENTE';
    }
  }
}

class Deliverable extends Equatable {
  final String id;
  final String titulo;
  final String descripcion;
  final DateTime? fechaEntregaEsperada;
  final String? archivoEntregadoURL;
  final DeliverableStatus estado;
  final double? precio;

  const Deliverable({
    required this.id,
    required this.titulo,
    required this.descripcion,
    this.fechaEntregaEsperada,
    this.archivoEntregadoURL,
    required this.estado,
    this.precio,
  });

  factory Deliverable.fromJson(Map<String, dynamic> json) {
    return Deliverable(
      id: json['id'],
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      fechaEntregaEsperada: json['fechaEntregaEsperada'] != null
          ? DateTime.tryParse(json['fechaEntregaEsperada'])
          : null,
      archivoEntregadoURL: json['archivoEntregadoURL'],
      estado: DeliverableStatusX.fromString(json['estado']),
      precio: (json['precio'] != null)
          ? (json['precio'] as num).toDouble()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descripcion': descripcion,
    'fechaEntregaEsperada':
    fechaEntregaEsperada?.toIso8601String(),
    'archivoEntregadoURL': archivoEntregadoURL,
    'estado': estado.backendValue,
    'precio': precio,
  };

  Deliverable copyWith({
    String? id,
    String? titulo,
    String? descripcion,
    DateTime? fechaEntregaEsperada,
    String? archivoEntregadoURL,
    DeliverableStatus? estado,
    double? precio,
  }) {
    return Deliverable(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      fechaEntregaEsperada: fechaEntregaEsperada ?? this.fechaEntregaEsperada,
      archivoEntregadoURL: archivoEntregadoURL ?? this.archivoEntregadoURL,
      estado: estado ?? this.estado,
      precio: precio ?? this.precio,
    );
  }


  @override
  List<Object?> get props => [
    id,
    titulo,
    descripcion,
    fechaEntregaEsperada,
    archivoEntregadoURL,
    estado,
    precio
  ];
}
