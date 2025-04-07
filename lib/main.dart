import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();

  // Forzar orientaciones permitidas
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FELCV',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        // Configuraciones responsivas para texto
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 13),
          bodyMedium: TextStyle(fontSize: 11),
          labelLarge: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        // Configuraciones responsivas para inputs
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      builder: (context, child) {
        // Asegurar que el texto se escale correctamente
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0),
          ),
          child: child!,
        );
      },
      home: const LoginScreen(),
    );
  }
}
