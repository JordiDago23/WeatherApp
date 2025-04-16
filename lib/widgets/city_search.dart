import 'package:flutter/material.dart';
import '../models/city_model.dart';

class CitySearch extends StatefulWidget {
  final Function(String) onCitySelected;
  final List<City> recentCities;

  const CitySearch({
    Key? key,
    required this.onCitySelected,
    required this.recentCities,
  }) : super(key: key);

  @override
  State<CitySearch> createState() => _CitySearchState();
}

class _CitySearchState extends State<CitySearch> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Buscar ciudad',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                widget.onCitySelected(value);
                _controller.clear();
              }
            },
          ),
        ),
        if (widget.recentCities.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ciudades recientes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        widget.recentCities.map((city) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ActionChip(
                              avatar: const Icon(Icons.location_city, size: 16),
                              label: Text(city.name),
                              onPressed: () {
                                widget.onCitySelected(city.name);
                              },
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
