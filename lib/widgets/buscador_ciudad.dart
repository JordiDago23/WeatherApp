import 'package:flutter/material.dart';
import 'package:weather_app_jml/theme/theme_data.dart';
import 'package:weather_app_jml/services/servicio_api.dart';
import 'package:weather_app_jml/models/ciudad_sugerida_model.dart';

class BuscadorCiudad extends StatefulWidget {
  final Function(String) onCitySelected;

  const BuscadorCiudad({super.key, required this.onCitySelected});

  @override
  State<BuscadorCiudad> createState() => _BuscadorCiudadState();
}

class _BuscadorCiudadState extends State<BuscadorCiudad> {
  final TextEditingController _controller = TextEditingController();
  final ServicioApi _servicioApi = ServicioApi();
  List<CiudadSugerida> _sugerencias = [];
  bool _estaBuscando = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _buscarSugerencias(String consulta) async {
    if (consulta.isEmpty) {
      setState(() {
        _sugerencias = [];
        _estaBuscando = false;
      });
      return;
    }

    setState(() => _estaBuscando = true);

    try {
      final sugerencias = await _servicioApi.buscarCiudades(consulta);
      setState(() {
        _sugerencias = sugerencias;
        _estaBuscando = false;
      });
    } catch (e) {
      setState(() {
        _sugerencias = [];
        _estaBuscando = false;
      });
    }
  }

  void _seleccionarCiudad(CiudadSugerida ciudad) {
    widget.onCitySelected(ciudad.nombreCompleto);
    _controller.clear();
    setState(() => _sugerencias = []);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Buscar ciudad...',
            prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                setState(() => _sugerencias = []);
              },
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onChanged: _buscarSugerencias,
        ),
        if (_estaBuscando)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          )
        else if (_sugerencias.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).cardColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _sugerencias.length,
              itemBuilder: (context, index) {
                final ciudad = _sugerencias[index];
                return ListTile(
                  title: Text(
                    ciudad.nombreCompleto,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  onTap: () => _seleccionarCiudad(ciudad),
                );
              },
            ),
          ),
      ],
    );
  }
}
