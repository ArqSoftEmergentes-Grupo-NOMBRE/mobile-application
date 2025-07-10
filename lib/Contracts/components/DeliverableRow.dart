import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../shared/constants/app_sizes.dart';
import '../models/deliverable.dart';

typedef DateCallback = void Function(DateTime);

class DeliverableRow extends StatelessWidget {
  final Deliverable deliverable;
  final bool editable;
  final ValueChanged<String>? onTitleChanged;
  final ValueChanged<String>? onDescriptionChanged;
  final ValueChanged<String>? onPriceChanged;
  final DateCallback? onDeadlinePicked;

  const DeliverableRow({
    Key? key,
    required this.deliverable,
    this.editable = false,
    this.onTitleChanged,
    this.onDescriptionChanged,
    this.onPriceChanged,
    this.onDeadlinePicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deadlineFormatted = deliverable.fechaEntregaEsperada != null
        ? DateFormat('yyyy-MM-dd').format(deliverable.fechaEntregaEsperada!)
        : 'Sin fecha';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título
        TextFormField(
          initialValue: deliverable.titulo ?? '',
          decoration: const InputDecoration(
            hintText: 'Título del entregable',
          ),
          enabled: editable,
          onChanged: onTitleChanged,
        ),
        const SizedBox(height: AppSizes.paddingS),

        // Descripción
        TextFormField(
          initialValue: deliverable.descripcion ?? '',
          decoration: const InputDecoration(
            hintText: 'Descripción',
          ),
          enabled: editable,
          onChanged: onDescriptionChanged,
        ),
        const SizedBox(height: AppSizes.paddingS),

        // Precio
        TextFormField(
          initialValue: deliverable.precio?.toStringAsFixed(2) ?? '',
          decoration: const InputDecoration(
            hintText: 'Precio (USD)',
          ),
          keyboardType: TextInputType.number,
          enabled: editable,
          onChanged: onPriceChanged,
        ),
        const SizedBox(height: AppSizes.paddingS),

        // Fecha de entrega esperada
        Row(
          children: [
            Text('Fecha esperada: $deadlineFormatted'),
            if (editable)
              IconButton(
                icon: const Icon(
                  Icons.calendar_today,
                  size: AppSizes.iconSizeM,
                ),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: deliverable.fechaEntregaEsperada ?? DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                  );
                  if (picked != null && onDeadlinePicked != null) {
                    onDeadlinePicked!(picked);
                  }
                },
              ),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
