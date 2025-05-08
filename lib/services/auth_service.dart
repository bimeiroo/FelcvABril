import 'dart:convert';
import 'package:felcv/services/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/usuario.dart';
import 'package:logging/logging.dart';

class AuthService {
  final SharedPreferences _prefs;
  final _logger = Logger('AuthService');
  static const String _usuarioActualKey = 'usuario_actual';

  AuthService(this._prefs);

  Future<bool> registrarUsuario(Usuario usuario) async {
    try {
      final response = await supabase.auth.signUp(
        email: usuario.usuario,
        password: usuario.password,
      );
      if (response.user != null) {
        await makeRpc(
          'auth_registrar_usuario',
          params: {
            'p_auth': response.user!.id,
            'p_nombre': usuario.nombre,
            'p_apellido': usuario.apellido,
            'p_grado': usuario.grado,
            'p_usuario': usuario.usuario,
            'p_carnet': usuario.carnet,
            'p_telefono': usuario.telefono,
            'p_rol': usuario.rol
          },
        );
        _logger.info('Usuario registrado: ${usuario.usuario}');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      _logger.severe('Error al registrar usuario: $e');
      return false;
    }
  }

  Future<Usuario?> login(String usuario, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: usuario,
        password: password,
      );

      final Session? session = response.session;
      if (session == null) {
        _logger.warning('Error de autenticación');
        return null;
      }
      final userSupa = (supabase.auth.currentUser)?.id;
      final usuarioEncontrado = await getFuncionario(userSupa!);

      // Guardar el usuario actual
      await _prefs.setString(
          _usuarioActualKey, jsonEncode(usuarioEncontrado.toJson()));

      _logger.info('Login exitoso: ${usuarioEncontrado.usuario}');
      return usuarioEncontrado;
    } catch (e) {
      _logger.warning('Error en login: $e');
      return null;
    }
  }

  Future<void> logout() async {
    await _prefs.remove(_usuarioActualKey);
    _logger.info('Logout exitoso');
  }

  Future<Usuario> getFuncionario(String userAuth) async {
    final response =
        await makeRpc('auth_datos_sesion', params: {'p_id_auth': userAuth});
    return fromJsonUsuario(response);
  }
}
