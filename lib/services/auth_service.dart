import 'dart:convert';
import 'package:felcv/services/supabase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/usuario.dart';
import 'package:logging/logging.dart';

class AuthService {
  final SharedPreferences _prefs;
  final _logger = Logger('AuthService');
  static const String _usuariosKey = 'usuarios';
  static const String _usuarioActualKey = 'usuario_actual';

  AuthService(this._prefs);

  Future<bool> registrarUsuario(Usuario usuario) async {
    try {
      final usuarios = null;// await getFuncionarios();

      // Verificar si ya existe un usuario con el mismo nombre de usuario
      if (usuarios.any((u) => u.usuario == usuario.usuario)) {
        _logger.warning('Usuario ya existe: ${usuario.usuario}');
        return false;
      }

      usuarios.add(usuario);
      final usuariosJson = usuarios.map((u) => u.toJson()).toList();
      final resultado =
          await _prefs.setString(_usuariosKey, jsonEncode(usuariosJson));

      _logger.info('Usuario registrado: ${usuario.usuario}');
      return resultado;
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
