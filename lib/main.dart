import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather_app_jml/screens/home_screen.dart';
import 'package:weather_app_jml/theme/theme_data.dart';
import 'package:weather_app_jml/services/notification_service.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await NotificationService.init();

  try {
    await dotenv.load(fileName: ".env");
    debugPrint("Archivo .env cargado correctamente");
  } catch (e) {
    debugPrint("Error al cargar archivo .env: $e");
  }

  await initializeDateFormatting('es');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App JML',
      theme: AppTheme.modoClaro(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es'), Locale('en')],
      locale: const Locale('es'),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
