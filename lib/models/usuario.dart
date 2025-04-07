class Usuario {
  final String id;
  final String nombre;
  final String apellido;
  final String grado;
  final String usuario;
  final String password;
  final String carnet;
  final String telefono;
  final String rol;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.grado,
    required this.usuario,
    required this.password,
    required this.carnet,
    required this.telefono,
    this.rol = 'funcionario',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'apellido': apellido,
      'grado': grado,
      'usuario': usuario,
      'password': password,
      'carnet': carnet,
      'telefono': telefono,
      'rol': rol,
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      grado: json['grado'] as String,
      usuario: json['usuario'] as String,
      password: json['password'] as String,
      carnet: json['carnet'] as String,
      telefono: json['telefono'] as String,
      rol: json['rol'] as String? ?? 'funcionario',
    );
  }

  Usuario copyWith({
    String? id,
    String? nombre,
    String? apellido,
    String? grado,
    String? usuario,
    String? password,
    String? carnet,
    String? telefono,
    String? rol,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      grado: grado ?? this.grado,
      usuario: usuario ?? this.usuario,
      password: password ?? this.password,
      carnet: carnet ?? this.carnet,
      telefono: telefono ?? this.telefono,
      rol: rol ?? this.rol,
    );
  }

  String get nombreCompleto => '$grado $nombre $apellido';
}
