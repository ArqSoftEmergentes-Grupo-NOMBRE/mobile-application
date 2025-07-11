import 'package:flutter/material.dart';
import '../../shared/constants/app_sizes.dart';
import '../models/deliverable.dart';
import '../services/contract_service.dart';
import '../contracts_routes.dart';
import 'package:url_launcher/url_launcher_string.dart';


class ContractDeliveryScreen extends StatelessWidget {
  final String contractId;

  const ContractDeliveryScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalles de entrega')),
      body: FutureBuilder(
        future: ContractService().fetchById(contractId),
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          final contract = snap.data!;
          final deliverables = contract.deliverables;

          bool allDeliverablesDelivered(List<Deliverable> list) {
            return list.every((d) => d.estado == DeliverableStatus.ENTREGADO);
          }


          print('Estado actual del contrato: ${contract.status}');

          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: deliverables.length,
                    separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (_, i) {
                        final d = deliverables[i];
                        return ListTile(
                          title: Text(d.titulo),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (d.fechaEntregaEsperada != null)
                                Text('Entrega esperada: ${d.fechaEntregaEsperada!.toLocal().toIso8601String().split('T')[0]}'),
                              Text('Descripción: ${d.descripcion}'),
                              if (d.archivoEntregadoURL != null)
                                TextButton(
                                  onPressed: () {
                                    // Abre el archivo en el navegador o app correspondiente
                                    // Puede usar url_launcher si lo tienes instalado
                                    launchUrlString(d.archivoEntregadoURL!);
                                  },
                                  child: const Text('Ver archivo entregado'),
                                ),
                            ],
                          ),
                          trailing: Text(
                            d.precio != null ? '\$${d.precio!.toStringAsFixed(2)}' : 'S/. -',
                          ),
                        );
                      }
                  ),
                ),
                const SizedBox(height: AppSizes.paddingM),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      ContractsRoutes.signature,
                      arguments: contractId,
                    );
                  },
                  child: const Text('Ver firma'),
                ),

                if (contract.status == 'ENVIADO' && allDeliverablesDelivered(deliverables))
                  ElevatedButton.icon(
                    onPressed: () async {
                      final confirmed = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Finalizar contrato'),
                          content: const Text('¿Estás seguro de que deseas finalizar el contrato?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Aceptar'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        try {
                          await ContractService().finalizeContract(contract.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Contrato finalizado correctamente')),
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.check),
                    label: const Text('Aceptar entregas y finalizar contrato'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
