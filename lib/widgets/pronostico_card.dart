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
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: AppTheme.cardColor,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('E', 'es').format(pronostico.fecha),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('d MMM', 'es').format(pronostico.fecha),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const Spacer(),
            Image.network(
              'https://openweathermap.org/img/wn/${pronostico.icono}.png',
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${pronostico.temperatura.round()}°C',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  pronostico.descripcion,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
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
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: pronosticos.length,
        itemBuilder: (context, index) {
          return PronosticoCard(pronostico: pronosticos[index]);
        },
      ),
    );
  }
}
