import 'package:flutter/material.dart';
import 'package:weather_app_jml/models/alerta_metereologica_model.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_jml/theme/theme_data.dart';

class AlertaScreen extends StatelessWidget {
  final AlertaMetereologica alerta;
  final VoidCallback onClose;

  const AlertaScreen({super.key, required this.alerta, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerta Meteorológica'),
        backgroundColor: AppTheme.alertColor,
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
                  color: AppTheme.alertColor.withAlpha(51),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppTheme.alertColor,
                      size: 48,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        alerta.evento,
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
                            ).format(DateTime.parse(alerta.inicio)),
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            DateFormat(
                              'HH:mm',
                              'es',
                            ).format(DateTime.parse(alerta.inicio)),
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
                            ).format(DateTime.parse(alerta.fin)),
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            DateFormat(
                              'HH:mm',
                              'es',
                            ).format(DateTime.parse(alerta.fin)),
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
                    alerta.descripcion,
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
                    backgroundColor: AppTheme.alertColor,
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
