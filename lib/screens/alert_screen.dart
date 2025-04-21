import 'package:flutter/material.dart';
import 'package:weather_app_jml/models/alert_model.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_jml/theme/app_theme.dart';

class AlertScreen extends StatelessWidget {
  final WeatherAlert alert;
  final VoidCallback onClose;

  const AlertScreen({super.key, required this.alert, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerta Meteorológica'),
        backgroundColor: AppTheme.errorColor,
        foregroundColor: AppTheme.textColorLight,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppTheme.errorColor,
                      size: 48,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        alert.evento,
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text('Período de la alerta:', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Inicia',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat(
                              'dd/MM/yyyy',
                              'es',
                            ).format(DateTime.parse(alert.inicio)),
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            DateFormat(
                              'HH:mm',
                              'es',
                            ).format(DateTime.parse(alert.inicio)),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Termina',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat(
                              'dd/MM/yyyy',
                              'es',
                            ).format(DateTime.parse(alert.fin)),
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            DateFormat(
                              'HH:mm',
                              'es',
                            ).format(DateTime.parse(alert.fin)),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Text('Descripción:', style: theme.textTheme.titleLarge),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    alert.descripcion,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Cerrar Alerta',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
