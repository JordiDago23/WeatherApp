import 'package:flutter/material.dart';
import 'package:weather_app_jml/models/alert_model.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_jml/theme/app_theme.dart';

class WeatherAlerts extends StatelessWidget {
  final List<WeatherAlert> alerts;

  const WeatherAlerts({super.key, required this.alerts});

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
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
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            return AlertCard(alert: alerts[index]);
          },
        ),
      ],
    );
  }
}

class AlertCard extends StatelessWidget {
  final WeatherAlert alert;

  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppTheme.errorColor.withAlpha(51),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: AppTheme.errorColor),
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
                  'Desde: ${DateFormat('dd/MM HH:mm').format(DateTime.parse(alert.inicio))}',
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  'Hasta: ${DateFormat('dd/MM HH:mm').format(DateTime.parse(alert.fin))}',
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
