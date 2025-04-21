import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_jml/models/pronostico_model.dart';
import 'package:weather_app_jml/theme/theme_data.dart';

class PronosticoCard extends StatelessWidget {
  final Pronostico pronostico;

  const PronosticoCard({super.key, required this.pronostico});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppTheme.cardColor,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat('E', 'es').format(pronostico.fecha),
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat('d MMM', 'es').format(pronostico.fecha),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Image.network(
              'https://openweathermap.org/img/wn/${pronostico.icono}.png',
              width: 40,
              height: 40,
            ),
            Text(
              '${pronostico.temperatura.round()}°C',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              pronostico.descripcion,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class ListaPronostico extends StatelessWidget {
  final List<Pronostico> pronosticos;

  const ListaPronostico({super.key, required this.pronosticos});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pronosticos.length,
        itemBuilder: (context, index) {
          return PronosticoCard(pronostico: pronosticos[index]);
        },
      ),
    );
  }
}
