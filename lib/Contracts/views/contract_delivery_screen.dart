import 'package:flutter/material.dart';
import '../../shared/constants/app_sizes.dart';
import '../models/deliverable.dart';
import '../services/contract_service.dart';
import '../contracts_routes.dart';

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
                        subtitle: Text(
                          d.fechaEntregaEsperada != null
                              ? 'Entrega esperada: ${d.fechaEntregaEsperada!.toLocal().toIso8601String().split('T')[0]}'
                              : 'Sin fecha definida',
                        ),
                        trailing: Text(
                          d.precio != null
                              ? '\$${d.precio!.toStringAsFixed(2)}'
                              : 'S/. -',
                        ),
                      );
                    },
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
              ],
            ),
          );
        },
      ),
    );
  }
}
