import 'package:equatable/equatable.dart';
import 'package:felcv/models/denuncia.dart';
import 'package:felcv/models/usuario.dart';
import 'package:felcv/services/supabase_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(const SessionState());

  Future<void> getFuncionarios() async{
    try {
      final response = await makeRpc('obtener_usuarios',params: {'vid': 0});
      final List<Usuario> usuarios = [];
      for (var item in response['data']) {
        usuarios.add(fromJsonUsuario(item));
      }
      emit(state.copyWith(usuarios: usuarios));
    } catch (e) {
      emit(state.copyWith(usuarios:[]));
    }
  }

  Future<Usuario?> handleLogin(
    String usuario,
    String password,
  ) async {
    emit(state.copyWith(isLoading: true));
    final logger = Logger('AuthService');

    try {
      final response = await supabase.auth.signInWithPassword(
        email: usuario,
        password: password,
      );

      final Session? session = response.session;
      if (session == null) {
        logger.warning('Error de autenticación');
        return null;
      }
      final userSupa = (supabase.auth.currentUser)?.id;
      final usuarioEncontrado = await getFuncionario(userSupa!);
      await getFuncionarios();
    emit(state.copyWith(
      usuario: usuario,
      usuarioActual: usuarioEncontrado
    ));
      logger.info('Login exitoso: ${usuarioEncontrado.usuario}');
      emit(state.copyWith(isLoading: false));
      return usuarioEncontrado;
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      logger.warning('Error en login: $e');
      return null;
    }
  }
  Future<Usuario> getFuncionario(String userAuth) async {
    final response =
        await makeRpc('auth_datos_sesion', params: {'p_id_auth': userAuth});
    return fromJsonUsuario(response['data']);
  }

  Future<void> obtenerDenuncias() async{
    try {
      final response = await makeRpc('obtener_denuncias',params: {'vid': state.usuarioActual!.id});
      final List<Denuncia> denuncias = [];
      for (var item in response['data']) {
        Denuncia denuncia = fromJsonDenuncia(item);
        denuncias.add(denuncia);
      }
      emit(state.copyWith(denuncias: denuncias));
    } catch (e) {
      print(e);
    }
  }

  Future<void> buscarDenununciados(String valule)async {

    try {
      emit(state.copyWith(isLoading: true));
      final response = await makeRpc('obtener_denunciados',params: {'vid': state.usuarioActual!.id,'vnombre':'%$valule%'});
      final List<Denuncia> denuncias = [];
      for (var item in response['data']) {
        Denuncia denuncia = fromJsonDenuncia(item);
        denuncias.add(denuncia);
      }
      emit(state.copyWith(denuncias: denuncias,isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      print(e);
    }
  }

  
}
