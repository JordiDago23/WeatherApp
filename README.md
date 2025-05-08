# Mi Aplicación del Clima

Una aplicación de clima sencilla desarrollada en Flutter, ideal para estudiantes de programación móvil.

## Características

- Consulta del clima actual por geolocalización
- Búsqueda de clima por ciudad
- Pronóstico de 5 días
- Alertas meteorológicas
- Historial de ciudades recientes

## Requisitos

- Flutter 3.29.3 o superior
- Dart 3.7.2 o superior
- Conexión a Internet
- Cuenta en OpenWeatherMap para obtener una API key

## Configuración

1. Clona el repositorio a tu computadora
2. Ejecuta `flutter pub get` para instalar las dependencias
3. Crea una cuenta en [OpenWeatherMap](https://openweathermap.org/) y obtén una API key gratuita
4. Abre el archivo `.env` en la raíz del proyecto y reemplaza `tu_clave_api_aqui` con tu clave de API real:
   ```
   OPENWEATHERAPIKEY=tu_clave_api_aqui
   ```

## Ejecución

1. Conecta un dispositivo o inicia un emulador
2. Ejecuta el siguiente comando:
   ```
   flutter run
   ```

## Estructura del Proyecto

```
lib/
├── main.dart              # Punto de entrada de la aplicación
├── models/                # Modelos de datos
├── screens/               # Pantallas de la aplicación
├── services/              # Servicios (API, almacenamiento)
└── widgets/               # Widgets reutilizables
```

## Explicación del Código

Esta aplicación utiliza una arquitectura simple y clara:

- **Modelos**: Definen la estructura de los datos (clima, pronóstico, alertas, ciudades)
- **Servicios**: Manejan la comunicación con la API y el almacenamiento local
- **Widgets**: Componentes reutilizables para la interfaz de usuario
- **Pantallas**: Vistas principales de la aplicación

## Contacto

Si tienes preguntas o sugerencias, no dudes en contactarme.
