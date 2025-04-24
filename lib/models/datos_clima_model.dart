import 'package:weather_app_jml/models/clima_model.dart';
import 'package:weather_app_jml/models/pronostico_model.dart';

class DatosClima {
  final Clima climaActual;
  final List<Pronostico> pronosticos;
  final Map<DateTime, Clima> climaPorFecha;

  DatosClima({
    required this.climaActual,
    required this.pronosticos,
    required this.climaPorFecha,
  });

  Clima? obtenerClimaPorFecha(DateTime fecha) {
    final fechaNormalizada = DateTime(fecha.year, fecha.month, fecha.day);
    return climaPorFecha[fechaNormalizada];
  }

  factory DatosClima.fromJson(
    Map<String, dynamic> jsonActual,
    Map<String, dynamic> jsonPronostico,
  ) {
    final climaActual = Clima.fromJson(jsonActual);
    final pronosticos = <Pronostico>[];
    final climaPorFecha = <DateTime, Clima>{};

    if (jsonPronostico['list'] != null) {
      final Map<String, List<dynamic>> pronosticosPorDia = {};

      for (var item in jsonPronostico['list']) {
        String fecha = item['dt_txt'].toString().split(' ')[0];
        if (!pronosticosPorDia.containsKey(fecha)) {
          pronosticosPorDia[fecha] = [];
        }
        pronosticosPorDia[fecha]!.add(item);
      }

      pronosticosPorDia.forEach((fecha, items) {
        if (pronosticos.length < 5) {
          double tempMin = double.infinity;
          double tempMax = double.negativeInfinity;
          String descripcion = items[0]['weather'][0]['description'];
          String icono = items[0]['weather'][0]['icon'];
          int humedad = 0;
          double velocidadViento = 0;
          double tempPromedio = 0;

          for (var item in items) {
            double temp = item['main']['temp'].toDouble();
            tempMin = temp < tempMin ? temp : tempMin;
            tempMax = temp > tempMax ? temp : tempMax;
            tempPromedio += temp;
            humedad += item['main']['humidity'] as int;
            velocidadViento += item['wind']['speed'].toDouble();
          }

          tempPromedio /= items.length;
          humedad = (humedad / items.length).round();
          velocidadViento /= items.length;

          final pronostico = Pronostico.fromDailyForecasts(
            items.cast<Map<String, dynamic>>(),
          );
          pronosticos.add(pronostico);

          final fechaObj = DateTime.parse(fecha);
          final fechaNormalizada = DateTime(
            fechaObj.year,
            fechaObj.month,
            fechaObj.day,
          );

          if (fechaNormalizada.year == climaActual.fecha.year &&
              fechaNormalizada.month == climaActual.fecha.month &&
              fechaNormalizada.day == climaActual.fecha.day) {
            climaPorFecha[fechaNormalizada] = Clima(
              nombreCiudad: climaActual.nombreCiudad,
              temperatura: climaActual.temperatura,
              descripcion: climaActual.descripcion,
              temperaturaMinima: tempMin,
              temperaturaMaxima: tempMax,
              humedad: climaActual.humedad,
              velocidadViento: climaActual.velocidadViento,
              icono: climaActual.icono,
              fecha: climaActual.fecha,
            );
          } else {
            climaPorFecha[fechaNormalizada] = Clima(
              nombreCiudad: climaActual.nombreCiudad,
              temperatura: tempPromedio,
              descripcion: descripcion,
              temperaturaMinima: tempMin,
              temperaturaMaxima: tempMax,
              humedad: humedad,
              velocidadViento: velocidadViento,
              icono: icono,
              fecha: fechaObj,
            );
          }
        }
      });
    }

    return DatosClima(
      climaActual: climaActual,
      pronosticos: pronosticos,
      climaPorFecha: climaPorFecha,
    );
  }
}
