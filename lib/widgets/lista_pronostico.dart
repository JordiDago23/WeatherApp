import 'package:flutter/material.dart';
import 'package:weather_app_jml/models/pronostico_model.dart';
import 'package:weather_app_jml/widgets/pronostico_card.dart';

class ListaPronostico extends StatelessWidget {
  final List<Pronostico> pronosticos;
  final Function(Pronostico) onPronosticoSeleccionado;

  const ListaPronostico({
    super.key,
    required this.pronosticos,
    required this.onPronosticoSeleccionado,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pronosticos.length,
      itemBuilder: (context, index) {
        return PronosticoCard(
          pronostico: pronosticos[index],
          onTap: () => onPronosticoSeleccionado(pronosticos[index]),
        );
      },
    );
  }
}
