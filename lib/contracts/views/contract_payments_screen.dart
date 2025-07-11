// lib/contracts/views/contract_payments_screen.dart

import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:uuid/uuid.dart';
import '../../shared/constants/app_sizes.dart';
import '../../shared/constants/app_strings.dart';
import '../../shared/components/primary_button.dart';
import '../contracts_routes.dart';
import '../models/create_contract_args.dart';
import '../models/deliverable.dart';
import '../components/DeliverableRow.dart';

class ContractPaymentsScreen extends StatefulWidget {
  final CreateContractArgs args;
  const ContractPaymentsScreen({super.key, required this.args});

  @override
  State<ContractPaymentsScreen> createState() => _ContractPaymentsScreenState();
}

class _ContractPaymentsScreenState extends State<ContractPaymentsScreen> {
  final List<Deliverable> _deliverables = [];
  final Uuid _uuid = Uuid();
  String? _pickedFilePath;
  String? _pickedFileName;

  void _addDeliverable() {
    setState(() {
      _deliverables.add(
        Deliverable(
          id: _uuid.v4(),
          titulo: '',
          descripcion: '',
          estado: DeliverableStatus.PENDIENTE,
          precio: 0,
          fechaEntregaEsperada: DateTime.now(),
        ),
      );
    });
  }

  double get _total =>
      _deliverables.fold<double>(0, (sum, d) => sum + (d.precio ?? 0));

  Future<void> _pickReferenceFile() async {
    final typeGroup = XTypeGroup(label: 'todos', extensions: ['*']);
    final XFile? result = await openFile(acceptedTypeGroups: [typeGroup]);

    if (result != null) {
      setState(() {
        _pickedFilePath = result.path;
        _pickedFileName = result.name;
      });
    }
  }

  void _continue() {
    final reviewArgs = {
      'clientId': widget.args.clientId,
      'developerId': widget.args.developerId,
      'webServiceId': widget.args.webServiceId,
      'contractExplorerUrl': widget.args.contractExplorerUrl,
      'fechaInicio': widget.args.fechaInicio.toIso8601String(),
      'fechaFin': widget.args.fechaFin.toIso8601String(),
      'precioTotal': _total,
      'entregables': _deliverables.map((d) => d.toJson()).toList(),
      'referenceFile': _pickedFilePath,
    };

    Navigator.pushNamed(
      context,
      ContractsRoutes.review,
      arguments: reviewArgs,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.contractSignature)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _deliverables.length,
                itemBuilder: (ctx, i) {
                  final d = _deliverables[i];
                  return DeliverableRow(
                    deliverable: d,
                    editable: true,
                    onTitleChanged: (v) {
                      setState(() {
                        _deliverables[i] = d.copyWith(titulo: v);
                      });
                    },
                    onDescriptionChanged: (v) {
                      setState(() {
                        _deliverables[i] = d.copyWith(descripcion: v);
                      });
                    },
                    onPriceChanged: (v) {
                      final parsed = double.tryParse(v) ?? 0;
                      setState(() {
                        _deliverables[i] = d.copyWith(precio: parsed);
                      });
                    },
                    onDeadlinePicked: (picked) {
                      setState(() {
                        _deliverables[i] =
                            d.copyWith(fechaEntregaEsperada: picked);
                      });
                    },
                  );
                },
              ),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Agregar entregable'),
              onPressed: _addDeliverable,
            ),
            const SizedBox(height: AppSizes.paddingS),
            Text('Total: \$${_total.toStringAsFixed(2)}'),
            const SizedBox(height: AppSizes.paddingM),
            PrimaryButton(
              text: _pickedFileName ?? 'Adjuntar archivo de referencia',
              fullWidth: false,
              onPressed: _pickReferenceFile,
            ),
            const SizedBox(height: AppSizes.paddingL),
            PrimaryButton(
              text: 'Revisar contrato',
              onPressed: _continue,
            ),
          ],
        ),
      ),
    );
  }
}
