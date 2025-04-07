import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
      final usuarios = await getFuncionarios();

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
      final usuarios = await getFuncionarios();
      final usuarioEncontrado = usuarios.firstWhere(
        (u) => u.usuario == usuario && u.password == password,
        orElse: () => throw Exception('Usuario o contraseña incorrectos'),
      );

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

  Future<Usuario?> getCurrentUser() async {
    try {
      final usuarioJson = _prefs.getString(_usuarioActualKey);
      if (usuarioJson == null) return null;

      return Usuario.fromJson(jsonDecode(usuarioJson));
    } catch (e) {
      _logger.warning('Error al obtener usuario actual: $e');
      return null;
    }
  }

  Future<List<Usuario>> getFuncionarios() async {
    try {
      final usuariosJson = _prefs.getString(_usuariosKey);
      if (usuariosJson == null) return [];

      final List<dynamic> decoded = jsonDecode(usuariosJson);
      return decoded.map((json) => Usuario.fromJson(json)).toList();
    } catch (e) {
      _logger.severe('Error al obtener funcionarios: $e');
      return [];
    }
  }

  Future<List<Usuario>> getUsuarios() async {
    return await getFuncionarios();
  }
}
