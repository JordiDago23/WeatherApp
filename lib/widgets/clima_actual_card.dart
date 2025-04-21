import 'package:flutter/material.dart';
import 'package:weather_app_jml/models/clima_model.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_jml/theme/theme_data.dart';

class ClimaActualCard extends StatelessWidget {
  final Clima clima;

  const ClimaActualCard({super.key, required this.clima});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(clima.nombreCiudad, style: theme.textTheme.displayMedium),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, d MMMM', 'es').format(clima.fecha),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://openweathermap.org/img/wn/${clima.icono}@2x.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${clima.temperatura.round()}°C',
                      style: theme.textTheme.displayLarge,
                    ),
                    Text(clima.descripcion, style: theme.textTheme.bodyLarge),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoClima(
                  Icons.arrow_downward,
                  '${clima.temperaturaMinima.round()}°C',
                  'Mínima',
                  AppTheme.temperaturaBajaColor,
                ),
                _buildInfoClima(
                  Icons.arrow_upward,
                  '${clima.temperaturaMaxima.round()}°C',
                  'Máxima',
                  AppTheme.temperaturaAltaColor,
                ),
                _buildInfoClima(
                  Icons.water_drop,
                  '${clima.humedad}%',
                  'Humedad',
                  AppTheme.humedadColor,
                ),
                _buildInfoClima(
                  Icons.air,
                  '${clima.velocidadViento} km/h',
                  'Viento',
                  AppTheme.vientoColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoClima(
    IconData icono,
    String valor,
    String label,
    Color colorIcono,
  ) {
    return Column(
      children: [
        Icon(icono, size: 24, color: colorIcono),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: AppTheme.textColorSecondary),
        ),
      ],
    );
  }
}
