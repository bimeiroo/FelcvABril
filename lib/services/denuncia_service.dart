import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import '../models/denuncia.dart';

class DenunciaService {
  static const String _key = 'denuncias';
  SharedPreferences? _prefs;
  final _logger = Logger('DenunciaService');

  DenunciaService() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      // ignore: avoid_print
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  Future<void> _initPrefs() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      _logger.info('SharedPreferences inicializado correctamente');
    } catch (e) {
      _logger.severe('Error al inicializar SharedPreferences: $e');
      throw Exception('No se pudo inicializar SharedPreferences');
    }
  }

  Future<List<Denuncia>> getDenuncias() async {
    await _initPrefs();
    return _obtenerDenuncias();
  }

  Future<bool> guardarDenuncia(Denuncia denuncia) async {
    try {
      await _initPrefs();
      _logger.info('Guardando denuncia: ${denuncia.numeroDenuncia}');
      _logger.info('Datos del denunciante:');
      _logger.info('Nombre: ${denuncia.nombreDenunciante}');
      _logger.info('Apellido: ${denuncia.apellidoDenunciante}');
      _logger.info('CI: ${denuncia.ciDenunciante}');

      final denuncias = await _obtenerDenuncias();
      final index = denuncias.indexWhere((d) => d.id == denuncia.id);
      if (index != -1) {
        denuncias[index] = denuncia;
      } else {
        denuncias.add(denuncia);
      }

      final resultado = await _guardarDenuncias(denuncias);
      _logger.info('Denuncia guardada correctamente: $resultado');
      return resultado;
    } catch (e) {
      _logger.severe('Error al guardar denuncia: $e');
      return false;
    }
  }

  Future<bool> actualizarDenuncia(Denuncia denuncia) async {
    try {
      _logger.info('Iniciando actualización de denuncia');
      _logger.info('ID de la denuncia: ${denuncia.id}');
      _logger.info('Número de denuncia: ${denuncia.numeroDenuncia}');

      _prefs ??= await SharedPreferences.getInstance();

      if (_prefs == null) {
        _logger.severe('No se pudo inicializar SharedPreferences');
        return false;
      }

      final denuncias = await _obtenerDenuncias();
      _logger
          .info('Total de denuncias antes de actualizar: ${denuncias.length}');

      final index = denuncias.indexWhere((d) => d.id == denuncia.id);
      if (index == -1) {
        _logger.warning('No se encontró la denuncia con ID: ${denuncia.id}');
        return false;
      }

      _logger.info('Denuncia encontrada en el índice: $index');
      denuncias[index] = denuncia;

      final denunciasJson = denuncias.map((d) => d.toJson()).toList();
      final resultado =
          await _prefs!.setString('denuncias', jsonEncode(denunciasJson));

      _logger.info('Resultado de guardar denuncias: $resultado');
      return resultado;
    } catch (e) {
      _logger.severe('Error al actualizar denuncia: $e');
      return false;
    }
  }

  Future<bool> eliminarDenuncia(String id) async {
    await _initPrefs();
    try {
      final denuncias = await _obtenerDenuncias();
      denuncias.removeWhere((d) => d.id == id);
      return await _guardarDenuncias(denuncias);
    } catch (e) {
      _logger.severe('Error al eliminar denuncia: $e');
      return false;
    }
  }

  Future<List<Denuncia>> _obtenerDenuncias() async {
    try {
      if (_prefs == null) {
        throw Exception('SharedPreferences no está inicializado');
      }

      final denunciasJson = _prefs!.getString(_key);
      _logger.info('Denuncias obtenidas de SharedPreferences: $denunciasJson');

      if (denunciasJson != null) {
        final List<dynamic> list = jsonDecode(denunciasJson);
        final denuncias = list.map((json) => Denuncia.fromJson(json)).toList();
        _logger.info('Número de denuncias recuperadas: ${denuncias.length}');
        return denuncias;
      }
    } catch (e) {
      _logger.severe('Error al obtener denuncias: $e');
    }
    return [];
  }

  Future<bool> _guardarDenuncias(List<Denuncia> denuncias) async {
    try {
      if (_prefs == null) {
        await _initPrefs();
      }

      if (_prefs == null) {
        throw Exception('No se pudo inicializar SharedPreferences');
      }

      // Convertir la lista de denuncias a JSON
      final denunciasJson =
          jsonEncode(denuncias.map((d) => d.toJson()).toList());

      // Guardar en SharedPreferences
      final resultado = await _prefs!.setString(_key, denunciasJson);

      if (!resultado) {
        _logger.warning('No se pudo guardar en SharedPreferences');
        return false;
      }

      _logger.info('Denuncias guardadas exitosamente');
      return true;
    } catch (e) {
      _logger.severe('Error al guardar denuncias: $e');
      return false;
    }
  }

  Future<List<Denuncia>> buscarDenuncias(String query) async {
    await _initPrefs();
    try {
      final denuncias = await getDenuncias();
      if (query.isEmpty) return denuncias;

      return denuncias.where((denuncia) {
        return denuncia.numeroDenuncia
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            denuncia.nombreDenunciante
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            denuncia.apellidoDenunciante
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            denuncia.ciDenunciante.contains(query) ||
            denuncia.tipoDenuncia.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      _logger.severe('Error al buscar denuncias: $e');
      return [];
    }
  }
}
