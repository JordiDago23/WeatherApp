import 'package:flutter/material.dart';
import 'package:weather_app_jml/models/weather_model.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_jml/theme/app_theme.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({Key? key, required this.weather}) : super(key: key);

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
            Text(weather.cityName, style: theme.textTheme.displayMedium),
            const SizedBox(height: 8),
            Text(
              DateFormat('EEEE, d MMMM', 'es').format(weather.date),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.round()}°C',
                      style: theme.textTheme.displayLarge,
                    ),
                    Text(weather.description, style: theme.textTheme.bodyLarge),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildWeatherInfo(
                  Icons.arrow_downward,
                  '${weather.tempMin.round()}°C',
                  'Mínima',
                  AppTheme.tempColdColor,
                ),
                _buildWeatherInfo(
                  Icons.arrow_upward,
                  '${weather.tempMax.round()}°C',
                  'Máxima',
                  AppTheme.tempHotColor,
                ),
                _buildWeatherInfo(
                  Icons.water_drop,
                  '${weather.humidity}%',
                  'Humedad',
                  AppTheme.humidityColor,
                ),
                _buildWeatherInfo(
                  Icons.air,
                  '${weather.windSpeed} km/h',
                  'Viento',
                  AppTheme.windColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfo(
    IconData icon,
    String value,
    String label,
    Color iconColor,
  ) {
    return Column(
      children: [
        Icon(icon, size: 24, color: iconColor),
        const SizedBox(height: 4),
        Text(
          value,
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
