import 'package:felcv/core/app_helpers.dart';
import 'package:felcv/core/color_palette.dart';
import 'package:felcv/services/cubit/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_screen.dart';
import 'registro_usuario_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _usuarioController.text = '';
    _passwordController.text = '';
  }

  void _irARegistro() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistroUsuarioScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = context.watch<SessionCubit>();
    return Scaffold(
      backgroundColor: AppColors.backgroundColorlight, // <-- Cambiado aquí
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColorlight,
        elevation: 0, // opcional, para un look más limpio
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: widthScreenSize(),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                  ),
                  const SizedBox(height: 19),
                  const Text(
                    'FELCV',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // <-- texto blanco para contraste
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  // Aquí podrías usar TextFormField con filled + fillColor para contraste
                  TextFormField(
                    controller: _usuarioController,
                    decoration: InputDecoration(
                      labelText: 'Usuario',
                      labelStyle: const TextStyle(
                          color: Colors.black), // color del label
                      hintText: 'Ingrese su usuario',
                      hintStyle:
                          const TextStyle(color: Colors.grey), // color del hint
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person, color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.green[800]!,
                            width: 2), // borde al enfocar
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey[400]!), // borde normal
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su usuario';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(color: Colors.black),
                      hintText: 'Ingrese su contraseña',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock, color: Colors.black),
                      filled: true,
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.green[800]!, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingrese su contraseña';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: session.state.isLoading
                          ? null
                          : () {
                              if (!_formKey.currentState!.validate()) return;
                              setState(() {
                                session
                                    .handleLogin(
                                  _usuarioController.text.trim(),
                                  _passwordController.text.trim(),
                                )
                                    .then((value) {
                                  if (value['usuario'] != null) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(value['msg']),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                });
                              });
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        foregroundColor: Colors.white,
                      ),
                      child: session.state.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Iniciar Sesión'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: session.state.isLoading ? null : _irARegistro,
                    child: Text(
                      '¿No tienes cuenta? Regístrate',
                      style: TextStyle(color: Colors.green[800]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
