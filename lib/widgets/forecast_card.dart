import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_jml/models/forecast_model.dart';
import 'package:weather_app_jml/theme/app_theme.dart';

class ForecastCard extends StatelessWidget {
  final Forecast forecast;

  const ForecastCard({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              DateFormat('E', 'es').format(forecast.date),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              DateFormat('d MMM', 'es').format(forecast.date),
              style: theme.textTheme.bodyMedium,
            ),
            Image.network(
              'https://openweathermap.org/img/wn/${forecast.icon}.png',
              width: 40,
              height: 40,
            ),
            Text(
              '${forecast.temperature.round()}°C',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              forecast.description,
              style: theme.textTheme.bodyMedium,
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

class ForecastList extends StatelessWidget {
  final List<Forecast> forecasts;

  const ForecastList({Key? key, required this.forecasts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 160,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.length,
        itemBuilder: (context, index) {
          return ForecastCard(forecast: forecasts[index]);
        },
      ),
    );
  }
}
