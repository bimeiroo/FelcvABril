import 'package:felcv/core/app_helpers.dart';
import 'package:felcv/core/color_palette.dart';
import 'package:felcv/screens/login_screen.dart';
import 'package:felcv/services/cubit/session_cubit.dart';
import 'package:felcv/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'registrar_denuncia_screen.dart';
import 'buscar_denuncias_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = ColorPalette.of(context);
    final session = context.read<SessionCubit>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.background,
        foregroundColor: palette.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: widthScreenSize(),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.backgroundShawow,
                  child: Icon(
                    Icons.person_outline,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sistema de Denuncias',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'FELCV',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Bienvenido'.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${session.state.usuarioActual!.grado.trim()} ${session.state.usuarioActual!.nombre.trim()} ${session.state.usuarioActual!.apellido.trim()}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 48),
                _button(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegistrarDenunciaScreen(
                            context: context,
                          ),
                        ),
                      );
                    },
                    label: 'Registrar Denuncia'),
                const SizedBox(height: 16),
                _button(
                    onPressed: () {
                      session.obtenerDenuncias().then(
                        (value) {
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BuscarDenunciasScreen(),
                              ),
                            );
                          }
                        },
                      );
                    },
                    label: 'Buscar Denuncias'),
                const SizedBox(height: 16),
                _button(
                    onPressed: () {
                      supabase.auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    label: 'Salir'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _button({required void Function() onPressed, required String label}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundShawow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        onPressed: onPressed,
        label: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        icon: const Icon(
          Icons.arrow_forward,
          color: Color.fromARGB(255, 33, 243, 40),
        ),
      ),
    );
  }
}
