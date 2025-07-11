import 'package:flutter/material.dart';
import '../../shared/components/primary_button.dart';
import '../../shared/constants/app_sizes.dart';
import '../../shared/constants/app_strings.dart';
import '../models/contract.dart';
import '../models/enums.dart';
import '../models/deliverable.dart';
import '../services/contract_service.dart';

class ContractDetailsScreen extends StatelessWidget {
  final String contractId;
  const ContractDetailsScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.contractDetails)),
      body: FutureBuilder<Contract>(
        future: ContractService().fetchById(contractId),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          final contract = snap.data!;
          final total = contract.deliverables.fold<double>(
            0,
                (sum, d) => sum + (d.precio ?? 0),
          );

          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: ListView(
              children: [
                Text(
                  'Contrato #${contract.id}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSizes.paddingS),
                Text('Estado: ${contract.status}'),
                const SizedBox(height: AppSizes.paddingS),
                Text('Developer ID: ${contract.developerId}'),
                Text('WebService ID: ${contract.webServiceId}'),
                if (contract.contractExplorerUrl != null) ...[
                  const SizedBox(height: AppSizes.paddingS),
                  Text(
                    'Explorador: ${contract.contractExplorerUrl}',
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                ],
                const Divider(height: 32),
                const Text('Entregables:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSizes.paddingS),

                // Mostrar entregables
                ...contract.deliverables.map((d) => ListTile(
                  title: Text(d.titulo),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(d.descripcion),
                      if (d.fechaEntregaEsperada != null)
                        Text('Entrega esperada: '
                            '${d.fechaEntregaEsperada!.toLocal().toIso8601String().split('T')[0]}'),
                      Text('Estado: ${d.estado.name}'),
                    ],
                  ),
                  trailing: Text('\$${(d.precio ?? 0).toStringAsFixed(2)}'),
                )),

                const Divider(height: 32),
                Text('Total: \$${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSizes.paddingM),

                // Botón para firmar si el contrato está pendiente
                if (contract.status.toLowerCase() == 'pending')
                  PrimaryButton(
                    text: 'Firmar contrato',
                    onPressed: () async {
                      await ContractService().signContract(contract.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Contrato firmado.')),
                      );
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
