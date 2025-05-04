import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_jml/models/pronostico_model.dart';

class PronosticoCard extends StatelessWidget {
  final Pronostico pronostico;
  final VoidCallback onTap;

  const PronosticoCard({
    super.key,
    required this.pronostico,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormat('EEEE', 'es').format(pronostico.fecha),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontSize: 16),
                ),
              ),
              const SizedBox(width: 16),
              Image.network(
                'https://openweathermap.org/img/wn/${pronostico.icono}@2x.png',
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${pronostico.temperatura.round()}°C',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      pronostico.descripcion,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
