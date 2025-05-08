import 'package:flutter/material.dart';
import 'package:weather_app_jml/models/clima_model.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_jml/theme/theme_data.dart';
import 'package:fl_chart/fl_chart.dart';

class ClimaCard extends StatelessWidget {
  final Clima clima;
  final List<MapEntry<DateTime, double>> temperaturasPorHora;

  const ClimaCard({
    super.key,
    required this.clima,
    this.temperaturasPorHora = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Theme.of(context).cardColor,
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
            if (temperaturasPorHora.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildGraficoLineaTemperaturas(temperaturasPorHora),
            ],
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

  Widget _buildGraficoLineaTemperaturas(
    List<MapEntry<DateTime, double>> datos,
  ) {
    if (datos.isEmpty) return const SizedBox.shrink();
    final minTemp = datos.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final maxTemp = datos.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final int salto = 2;
    final int minY = minTemp.round();
    final int maxY = (((maxTemp.round() + salto) / salto).ceil()) * salto;
    final int maxRedondeado = (maxTemp.round() / salto).ceil() * salto;
    List<int> yLabels = [];

    int val = minY;
    while (val <= maxY) {
      yLabels.add(val);
      if (val >= maxRedondeado) break;
      val += salto;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 30, top: 8),
      child: SizedBox(
        height: 120,
        child: LineChart(
          LineChartData(
            minY: minY.toDouble(),
            maxY: maxY.toDouble(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    final intVal = value.round();
                    if (yLabels.contains(intVal)) {
                      return Text(
                        '$intVal',
                        style: const TextStyle(fontSize: 12),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  interval: 1,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    int idx = value.toInt();
                    if (idx >= 0 && idx < datos.length) {
                      final hora = datos[idx].key.hour.toString().padLeft(
                        2,
                        '0',
                      );
                      final minuto = datos[idx].key.minute.toString().padLeft(
                        2,
                        '0',
                      );
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          '$hora:$minuto',
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  interval: 1,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            gridData: FlGridData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (int i = 0; i < datos.length; i++)
                    FlSpot(i.toDouble(), datos[i].value),
                ],
                isCurved: true,
                color: AppTheme.temperaturaAltaColor,
                barWidth: 3,
                dotData: FlDotData(show: true),
              ),
            ],
            lineTouchData: LineTouchData(
              enabled: true,
              touchSpotThreshold: 30,
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: AppTheme.primaryColor.withAlpha(220),
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final idx = spot.spotIndex;
                    final temp = datos[idx].value.toStringAsFixed(1);
                    return LineTooltipItem(
                      '$temp°C',
                      const TextStyle(color: Colors.white, fontSize: 12),
                    );
                  }).toList();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
