import 'package:flutter/material.dart';
import '../../shared/constants/app_sizes.dart';
import '../services/contract_service.dart';
import '../models/contract.dart';

class ContractSignatureScreen extends StatelessWidget {
  final String contractId;
  const ContractSignatureScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firmas del contrato')),
      body: FutureBuilder<Contract>(
        future: ContractService().fetchById(contractId),
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          final c = snap.data!;

          return Padding(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contrato #${c.id}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Estado: ${c.status}'),
                const SizedBox(height: 8),
                Text('Client ID: ${c.clientId}'),
                Text('Developer ID: ${c.developerId}'),
                Text('WebService ID: ${c.webServiceId}'),
                const Divider(),
                const SizedBox(height: 8),

                const Text(
                  'Firma digital:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  c.contractExplorerUrl ?? '(No disponible)',
                  style: const TextStyle(color: Colors.blueAccent),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
