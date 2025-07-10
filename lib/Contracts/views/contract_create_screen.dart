import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../shared/components/custom_textfield.dart';
import '../../shared/components/primary_button.dart';
import '../../shared/constants/app_sizes.dart';
import '../../shared/constants/app_strings.dart';
import '../../shared/utils/validators.dart';
import '../models/create_contract_args.dart';
import '../contracts_routes.dart';

class ContractCreateScreen extends StatefulWidget {
  const ContractCreateScreen({super.key});

  @override
  State<ContractCreateScreen> createState() => _ContractCreateScreenState();
}

class _ContractCreateScreenState extends State<ContractCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientIdController = TextEditingController();
  final _developerIdController = TextEditingController(); // NUEVO
  final _webServiceIdController = TextEditingController();
  final _precioController = TextEditingController();
  final _explorerUrlController = TextEditingController();

  DateTime? _fechaInicio;
  DateTime? _fechaFin;

  final Uuid _uuid = Uuid();

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        isStart ? _fechaInicio = picked : _fechaFin = picked;
      });
    }
  }

  void _continue() {
    if (!_formKey.currentState!.validate() || _fechaInicio == null || _fechaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos requeridos')),
      );
      return;
    }

    final precioTexto = _precioController.text.trim();
    final precio = double.tryParse(precioTexto);

    if (precio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Precio inválido')),
      );
      return;
    }

    final args = CreateContractArgs(
      clientId: _uuid.v4(),
      developerId: _uuid.v4(),
      webServiceId: _uuid.v4(),
      fechaInicio: _fechaInicio!,
      fechaFin: _fechaFin!,
      precioTotal: precio,
      contractExplorerUrl: '',
      entregables: [],
    );


    Navigator.pushNamed(
      context,
      ContractsRoutes.payments,
      arguments: args,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Seleccionar fecha';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.contractDetails)),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              const SizedBox(height: AppSizes.paddingM),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selectDate(context, true),
                      child: Text('Inicio: ${_formatDate(_fechaInicio)}'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _selectDate(context, false),
                      child: Text('Fin: ${_formatDate(_fechaFin)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingM),
              CustomTextField(
                hint: 'Precio total',
                controller: _precioController,
                keyboardType: TextInputType.number,
                validator: Validators.required,
              ),
              const SizedBox(height: AppSizes.paddingM),

              const SizedBox(height: AppSizes.paddingL),
              PrimaryButton(
                text: AppStrings.nextButton,
                onPressed: _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
