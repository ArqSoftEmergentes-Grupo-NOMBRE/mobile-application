import 'package:equatable/equatable.dart';
import '../models/deliverable.dart';

class Contract extends Equatable {
  final String id;
  final String status;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final double? precioTotal;
  final String? contractExplorerUrl;
  final String clientId;
  final String developerId;
  final String webServiceId;
  final List<Deliverable> deliverables;

  const Contract({
    required this.id,
    required this.status,
    required this.fechaInicio,
    this.fechaFin,
    this.precioTotal,
    this.contractExplorerUrl,
    required this.clientId,
    required this.developerId,
    required this.webServiceId,
    required this.deliverables,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      status: json['status'],
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaFin: json['fechaFin'] != null ? DateTime.parse(json['fechaFin']) : null,
      precioTotal: (json['precioTotal'] != null)
          ? (json['precioTotal'] as num).toDouble()
          : null,
      contractExplorerUrl: json['contractExplorerUrl'],
      clientId: json['clientId'],
      developerId: json['developerId'],
      webServiceId: json['webServiceId'],
      deliverables: (json['entregables'] as List<dynamic>? ?? [])
          .map((e) => Deliverable.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'fechaInicio': fechaInicio.toIso8601String(),
    'fechaFin': fechaFin?.toIso8601String(),
    'precioTotal': precioTotal,
    'contractExplorerUrl': contractExplorerUrl,
    'clientId': clientId,
    'developerId': developerId,
    'webServiceId': webServiceId,
    'entregables': deliverables.map((e) => e.toJson()).toList(),
  };

  @override
  List<Object?> get props => [
    id,
    status,
    fechaInicio,
    fechaFin,
    precioTotal,
    contractExplorerUrl,
    clientId,
    developerId,
    webServiceId,
    deliverables
  ];
}
