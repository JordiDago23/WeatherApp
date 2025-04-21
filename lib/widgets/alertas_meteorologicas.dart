import 'package:flutter/material.dart';
import 'package:weather_app_jml/models/alerta_metereologica_model.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_jml/theme/theme_data.dart';

class AlertasMeteorologicas extends StatelessWidget {
  final List<AlertaMetereologica> alertas;

  const AlertasMeteorologicas({super.key, required this.alertas});

  @override
  Widget build(BuildContext context) {
    if (alertas.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Alertas meteorológicas', style: theme.textTheme.displaySmall),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: alertas.length,
          itemBuilder: (context, index) {
            return AlertaMetereologicaCard(alert: alertas[index]);
          },
        ),
      ],
    );
  }
}

class AlertaMetereologicaCard extends StatelessWidget {
  final AlertaMetereologica alert;

  const AlertaMetereologicaCard({super.key, required this.alert});

  String formatDateTime(String dateTimeString) {
    if (dateTimeString.isEmpty) return "N/A";
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd/MM HH:mm').format(dateTime);
    } catch (e) {
      return "Fecha inválida";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppTheme.alertColor.withAlpha(51),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppTheme.alertColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    alert.evento,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(alert.descripcion, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Desde: ${formatDateTime(alert.inicio)}',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  'Hasta: ${formatDateTime(alert.fin)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
