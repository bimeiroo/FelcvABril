part of 'session_cubit.dart';

class SessionState extends Equatable {
  final bool isLoading;
  final String errorMessage;
  final List<Usuario> usuarios;
  final String id;
  final String nombre;
  final String apellido;
  final String grado;
  final String usuario;
  final String password;
  final String carnet;
  final String telefono;
  final String rol;
  final Usuario? usuarioActual;
  final List<Denuncia> denuncias;

  const SessionState({
    this.isLoading = false,
    this.errorMessage = '',
    this.usuarios = const [],
    this.denuncias = const [],
    this.id = '',
    this.nombre = '',
    this.apellido = '',
    this.grado = '',
    this.usuario = '',
    this.password = '',
    this.carnet = '',
    this.telefono = '',
    this.rol = 'funcionario',
    this.usuarioActual,
  });

  SessionState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<Usuario>? usuarios,
    List<Denuncia>? denuncias,
    String? id,
    String? nombre,
    String? apellido,
    String? grado,
    String? usuario,
    String? password,
    String? carnet,
    String? telefono,
    String? rol,
    Usuario? usuarioActual,
  }) {
    return SessionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      usuarios: usuarios ?? this.usuarios,
      denuncias: denuncias ?? this.denuncias,
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      grado: grado ?? this.grado,
      usuario: usuario ?? this.usuario,
      password: password ?? this.password,
      carnet: carnet ?? this.carnet,
      telefono: telefono ?? this.telefono,
      rol: rol ?? this.rol,
      usuarioActual: usuarioActual ?? this.usuarioActual,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage,
        usuarios,
        denuncias,
        id,
        nombre,
        apellido,
        grado,
        usuario,
        password,
        carnet,
        telefono,
        rol,
        usuarioActual
      ];
}
