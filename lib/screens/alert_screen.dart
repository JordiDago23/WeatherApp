import 'package:flutter/material.dart';
import '../models/alert_model.dart';

class AlertScreen extends StatelessWidget {
  final WeatherAlert alert;
  final VoidCallback onClose;

  const AlertScreen({Key? key, required this.alert, required this.onClose})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('ALERTA METEOROLÓGICA'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Cabecera de alerta
            Container(
              color: Colors.red,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    alert.event,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Contenido de la alerta
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Descripción:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alert.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    _buildTimeInfo('Inicio', alert.startTime),
                    const SizedBox(height: 8),
                    _buildTimeInfo('Finalización', alert.endTime),
                    const SizedBox(height: 30),
                    const Text(
                      'Recomendaciones:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildRecommendation(
                      'Manténgase informado',
                      'Escuche la radio o TV para actualizaciones',
                      Icons.radio,
                    ),
                    _buildRecommendation(
                      'Siga las instrucciones',
                      'De las autoridades locales en todo momento',
                      Icons.follow_the_signs,
                    ),
                    _buildRecommendation(
                      'Tenga precaución',
                      'Evite actividades al aire libre si es posible',
                      Icons.umbrella,
                    ),
                  ],
                ),
              ),
            ),

            // Botón de cerrar
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'ENTENDIDO',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInfo(String label, String time) {
    DateTime? dateTime;
    try {
      dateTime = DateTime.parse(time);
    } catch (e) {
      // Si hay un error al parsear, no mostramos la fecha formateada
    }

    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          dateTime != null
              ? '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}'
              : time,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildRecommendation(String title, String description, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.red, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(description, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
