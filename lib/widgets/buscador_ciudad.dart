import 'package:flutter/material.dart';
import 'package:weather_app_jml/theme/theme_data.dart';

class BuscadorCiudad extends StatefulWidget {
  final Function(String) onCitySelected;

  const BuscadorCiudad({super.key, required this.onCitySelected});

  @override
  State<BuscadorCiudad> createState() => _BuscadorCiudadState();
}

class _BuscadorCiudadState extends State<BuscadorCiudad> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _buscarCiudad() {
    final city = _controller.text.trim();
    if (city.isNotEmpty) {
      widget.onCitySelected(city);
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Buscar ciudad...',
        prefixIcon: Icon(Icons.search, color: AppTheme.primaryColor),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => _controller.clear(),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (_) => _buscarCiudad(),
    );
  }
}
