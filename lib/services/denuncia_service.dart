import 'dart:convert';
import 'package:felcv/models/usuario.dart';
import 'package:felcv/services/helpers.dart';
import 'package:felcv/services/supabase_service.dart';
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

  Future<bool> guardarDenuncia(Denuncia denuncia, Usuario usuario) async {
    try {
      _logger.info('Iniciando guardado de denuncia');
      List<String> photoName = [];
      for (var i = 0; i < denuncia.imagenes.length; i++) {
        final path = denuncia.imagenes[i];
        final name = namePath();
        photoName.add(name);
        await uploadImage(path, name);
        _logger.info('Guardado de imagen : $path a $name');
      }
      final params = {
        'p_id_usuario': int.parse(usuario.id),
        'p_numero_denuncia': denuncia.numeroDenuncia,
        'p_fecha': formatearFecha(denuncia.fecha),
        'p_hora': denuncia.hora,
        'p_nombre_denunciante': denuncia.nombreDenunciante,
        'p_apellido_denunciante': denuncia.apellidoDenunciante,
        'p_ci_denunciante': denuncia.ciDenunciante,
        'p_telefono_denunciante': denuncia.telefonoDenunciante,
        'p_direccion_denunciante': denuncia.direccionDenunciante,
        'p_profesion_denunciante': denuncia.profesionDenunciante,
        'p_nombre_denunciado': denuncia.nombreDenunciado,
        'p_ci_denunciado': denuncia.ciDenunciado,
        'p_direccion_denunciado': denuncia.direccionDenunciado,
        'p_profesion_denunciado': denuncia.profesionDenunciado,
        'p_hechos': denuncia.hechos,
        'p_lugar': denuncia.lugar,
        'p_zona': denuncia.zona,
        'p_turno': denuncia.turno,
        'p_funcionario_asignado': int.parse(denuncia.funcionarioAsignado),
        'p_funcionario_adicional': int.parse(denuncia.funcionarioAdicional),
        'p_nombre_funcionario_asignado': denuncia.nombreFuncionarioAsignado,
        'p_nombre_funcionario_adicional': denuncia.nombreFuncionarioAdicional,
        'p_estado': denuncia.estado,
        'p_tipo_denuncia': denuncia.tipoDenuncia,
        'p_imagenes': photoName,
        'p_telefono_funcionario_adicional':
            denuncia.telefonoFuncionarioAdicional,
        'p_carnet_funcionario_adicional': denuncia.carnetFuncionarioAdicional,
        'p_sigla': denuncia.sigla,
        'p_latitud': double.tryParse( denuncia.latitud)??0,
        'p_logitud': double.tryParse(denuncia.longitud)??0,
      };

      final response = await makeRpc('den_insertar_denuncia', params: params);
      if (response == null) {
        _logger.severe('Error al insertar denuncia');
        return false;
      }

      _logger.info('Guardando denuncia: ${denuncia.numeroDenuncia}');
      _logger.info('Datos del denunciante:');
      _logger.info('Nombre: ${denuncia.nombreDenunciante}');
      _logger.info('Apellido: ${denuncia.apellidoDenunciante}');
      _logger.info('CI: ${denuncia.ciDenunciante}');

      return true;
    } catch (e) {
      _logger.severe('Error al guardar denuncia: $e');
      return false;
    }
  }

  Future<bool> actualizarDenuncia(Denuncia denuncia, Usuario usuario) async {
    try {
      _logger.info('Iniciando actualización de denuncia');
      _logger.info('ID de la denuncia: ${denuncia.id}');
      _logger.info('Número de denuncia: ${denuncia.numeroDenuncia}');

      final params = {
        'p_id_denuncia': int.parse(denuncia.id!),
        'p_id_usuario': int.parse(usuario.id),
        'p_numero_denuncia': denuncia.numeroDenuncia,
        'p_fecha': formatearFecha2(denuncia.fecha),
        'p_hora': denuncia.hora,
        'p_nombre_denunciante': denuncia.nombreDenunciante,
        'p_apellido_denunciante': denuncia.apellidoDenunciante,
        'p_ci_denunciante': denuncia.ciDenunciante,
        'p_telefono_denunciante': denuncia.telefonoDenunciante,
        'p_direccion_denunciante': denuncia.direccionDenunciante,
        'p_profesion_denunciante': denuncia.profesionDenunciante,
        'p_nombre_denunciado': denuncia.nombreDenunciado,
        'p_ci_denunciado': denuncia.ciDenunciado,
        'p_direccion_denunciado': denuncia.direccionDenunciado,
        'p_profesion_denunciado': denuncia.profesionDenunciado,
        'p_hechos': denuncia.hechos,
        'p_lugar': denuncia.lugar,
        'p_zona': denuncia.zona,
        'p_turno': denuncia.turno,
        'p_funcionario_asignado': int.parse(denuncia.funcionarioAsignado),
        'p_funcionario_adicional': int.parse(denuncia.funcionarioAdicional),
        'p_nombre_funcionario_asignado': denuncia.nombreFuncionarioAsignado,
        'p_nombre_funcionario_adicional': denuncia.nombreFuncionarioAdicional,
        'p_estado': denuncia.estado,
        'p_tipo_denuncia': denuncia.tipoDenuncia,
        'p_telefono_funcionario_adicional':
            denuncia.telefonoFuncionarioAdicional,
        'p_carnet_funcionario_adicional': denuncia.carnetFuncionarioAdicional,
        'p_sigla': denuncia.sigla,
        'p_latitud': denuncia.latitud,
        'p_logitud': denuncia.longitud,
      };

      final response = await makeRpc('den_actualizar_denuncia', params: params);
      if (response == null) {
        _logger.severe('Error al insertar denuncia');
        return false;
      }

      _logger.info('Resultado de guardar denuncias');
      return true;
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

  Future<Denuncia> encontrarDenuncia(Denuncia denuncia) async {
    try {
      final params = {
        'vid': int.parse(denuncia.id!),
      };
      final response = await makeRpc('den_encontrar_denuncia', params: params);
      return fromJsonDenuncia(response['data']);
    } catch (e) {
      return fromJsonDenuncia({});
    }
  }
}
