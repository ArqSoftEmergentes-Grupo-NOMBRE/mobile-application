import 'deliverable.dart';

class CreateContractArgs {
  final String clientId;
  final String developerId;
  final String webServiceId;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final double precioTotal;
  final String? contractExplorerUrl;
  final List<Deliverable> entregables;

  CreateContractArgs({
    required this.clientId,
    required this.developerId,
    required this.webServiceId,
    required this.fechaInicio,
    required this.fechaFin,
    required this.precioTotal,
    this.contractExplorerUrl,
    required this.entregables,
  });

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'developerId': developerId,
      'webServiceId': webServiceId,
      'fechaInicio': fechaInicio.toIso8601String().split('T')[0],
      'fechaFin': fechaFin.toIso8601String().split('T')[0],
      'precioTotal': precioTotal,
      'contractExplorerUrl': contractExplorerUrl ?? '',
      'entregables': entregables.map((e) => e.toJson()).toList(),
    };
  }
}
