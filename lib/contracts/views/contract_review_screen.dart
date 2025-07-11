import 'package:flutter/material.dart';
import '../../shared/constants/app_sizes.dart';
import '../../shared/constants/app_strings.dart';
import '../../shared/components/primary_button.dart';
import '../contracts_routes.dart';
import '../services/contract_service.dart';
import '../models/create_contract_args.dart';
import '../models/deliverable.dart';

class ContractReviewScreen extends StatefulWidget {
  final Map<String, dynamic> contractData;
  const ContractReviewScreen({super.key, required this.contractData});

  @override
  State<ContractReviewScreen> createState() => _ContractReviewScreenState();
}

class _ContractReviewScreenState extends State<ContractReviewScreen> {
  bool _accepted = false;
  bool _sending = false;

  List<Map<String, dynamic>> get _deliverables =>
      List<Map<String, dynamic>>.from(widget.contractData['entregables'] ?? []);

  double get _total => _deliverables.fold<double>(
    0,
        (sum, d) => sum + (double.tryParse(d['precio']?.toString() ?? '') ?? 0),
  );

  void _onSend() async {
    if (!_accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes aceptar y firmar el contrato.')),
      );
      return;
    }

    setState(() => _sending = true);

    try {
      final data = widget.contractData;

      debugPrint('[DEBUG] Campos críticos:');
      debugPrint('clientId: ${data['clientId']}');
      debugPrint('developerId: ${data['developerId']}');
      debugPrint('webServiceId: ${data['webServiceId']}');
      debugPrint('contractExplorerUrl: ${data['contractExplorerUrl']}');


      final args = CreateContractArgs(
        clientId: data['clientId'],
        developerId: data['developerId'],
        webServiceId: data['webServiceId'],
        fechaInicio: DateTime.now(),
        fechaFin: DateTime.now().add(const Duration(days: 30)),
        precioTotal: _total,
        contractExplorerUrl: data['contractExplorerUrl'] ?? '',
        entregables: _deliverables.map((d) {
          return Deliverable(
            id: '',
            titulo: d['titulo'] ?? '',
            descripcion: d['descripcion'] ?? '',
            fechaEntregaEsperada: DateTime.tryParse(d['fechaEntregaEsperada'] ?? ''),
            estado: DeliverableStatus.PENDIENTE,
            precio: double.tryParse(d['precio']?.toString() ?? '0') ?? 0,
            archivoEntregadoURL: '',
          );
        }).toList(),
      );

      // 🔍 LOG en consola
      debugPrint('[DEBUG] JSON a enviar:\n${args.toJson()}', wrapWidth: 1024);

      await ContractService().createContract(args);

      if (mounted) {
        setState(() => _sending = false);
        Navigator.pushReplacementNamed(context, ContractsRoutes.success);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _sending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear contrato: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.contractData;
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.contractSignature)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: ListView(
          children: [
            Text(
              '${AppStrings.noAccount} ${data['developerId']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${AppStrings.newContract}: ${data['title'] ?? 'Sin título'}'),
            Text('${AppStrings.contractSummary}: ${data['description'] ?? 'Sin resumen'}'),
            const SizedBox(height: 20),
            const Text('Entregables:', style: TextStyle(fontWeight: FontWeight.bold)),
            ..._deliverables.map((d) => ListTile(
              title: Text(d['titulo'] ?? ''),
              subtitle: Text('Fecha esperada: ${d['fechaEntregaEsperada'] ?? ''}'),
              trailing: Text('\$${d['precio']}'),
            )),
            const Divider(),
            Text(
              '${AppStrings.paymentMethod}: \$${_total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSizes.paddingL),
            CheckboxListTile(
              value: _accepted,
              onChanged: (v) => setState(() => _accepted = v ?? false),
              title: const Text('Confirmo que revisé y acepto.'),
            ),
            const SizedBox(height: AppSizes.paddingL),
            PrimaryButton(
              text: _sending ? 'Enviando…' : 'Enviar',
              isLoading: _sending,
              onPressed: _sending ? null : _onSend,
            ),
          ],
        ),
      ),
    );
  }
}
