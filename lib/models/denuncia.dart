class Denuncia {
  final String id;
  final String numeroDenuncia;
  final String fecha;
  final String hora;
  final String nombreDenunciante;
  final String apellidoDenunciante;
  final String ciDenunciante;
  final String telefonoDenunciante;
  final String direccionDenunciante;
  final String profesionDenunciante;
  final String nombreDenunciado;
  final String ciDenunciado;
  final String direccionDenunciado;
  final String profesionDenunciado;
  final String hechos;
  final String lugar;
  final String zona;
  final String turno;
  final List<String> imagenes;
  final String funcionarioAsignado;
  final String funcionarioAdicional;
  final String nombreFuncionarioAsignado;
  final String nombreFuncionarioAdicional;
  final String estado;
  final String tipoDenuncia;
  final DateTime fechaRegistro;

  Denuncia({
    required this.id,
    required this.numeroDenuncia,
    required this.fecha,
    required this.hora,
    required this.nombreDenunciante,
    required this.apellidoDenunciante,
    required this.ciDenunciante,
    required this.telefonoDenunciante,
    required this.direccionDenunciante,
    required this.profesionDenunciante,
    required this.nombreDenunciado,
    required this.ciDenunciado,
    required this.direccionDenunciado,
    required this.profesionDenunciado,
    required this.hechos,
    required this.lugar,
    required this.zona,
    required this.turno,
    required this.imagenes,
    required this.funcionarioAsignado,
    required this.funcionarioAdicional,
    required this.nombreFuncionarioAsignado,
    required this.nombreFuncionarioAdicional,
    required this.estado,
    required this.tipoDenuncia,
    required this.fechaRegistro,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numeroDenuncia': numeroDenuncia,
      'fecha': fecha,
      'hora': hora,
      'nombreDenunciante': nombreDenunciante,
      'apellidoDenunciante': apellidoDenunciante,
      'ciDenunciante': ciDenunciante,
      'telefonoDenunciante': telefonoDenunciante,
      'direccionDenunciante': direccionDenunciante,
      'profesionDenunciante': profesionDenunciante,
      'nombreDenunciado': nombreDenunciado,
      'ciDenunciado': ciDenunciado,
      'direccionDenunciado': direccionDenunciado,
      'profesionDenunciado': profesionDenunciado,
      'hechos': hechos,
      'lugar': lugar,
      'zona': zona,
      'turno': turno,
      'imagenes': imagenes,
      'funcionarioAsignado': funcionarioAsignado,
      'funcionarioAdicional': funcionarioAdicional,
      'nombreFuncionarioAsignado': nombreFuncionarioAsignado,
      'nombreFuncionarioAdicional': nombreFuncionarioAdicional,
      'estado': estado,
      'tipoDenuncia': tipoDenuncia,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }

  factory Denuncia.fromJson(Map<String, dynamic> json) {
    return Denuncia(
      id: json['id'] as String,
      numeroDenuncia: json['numeroDenuncia'] as String,
      fecha: json['fecha'] as String,
      hora: json['hora'] as String,
      nombreDenunciante: json['nombreDenunciante'] as String,
      apellidoDenunciante: json['apellidoDenunciante'] as String,
      ciDenunciante: json['ciDenunciante'] as String,
      telefonoDenunciante: json['telefonoDenunciante'] as String,
      direccionDenunciante: json['direccionDenunciante'] as String,
      profesionDenunciante: json['profesionDenunciante'] as String,
      nombreDenunciado: json['nombreDenunciado'] as String,
      ciDenunciado: json['ciDenunciado'] as String,
      direccionDenunciado: json['direccionDenunciado'] as String,
      profesionDenunciado: json['profesionDenunciado'] as String,
      hechos: json['hechos'] as String,
      lugar: json['lugar'] as String,
      zona: json['zona'] as String,
      turno: json['turno'] as String,
      imagenes: List<String>.from(json['imagenes'] as List),
      funcionarioAsignado: json['funcionarioAsignado'] as String,
      funcionarioAdicional: json['funcionarioAdicional'] as String,
      nombreFuncionarioAsignado: json['nombreFuncionarioAsignado'] as String,
      nombreFuncionarioAdicional: json['nombreFuncionarioAdicional'] as String,
      estado: json['estado'] as String,
      tipoDenuncia: json['tipoDenuncia'] as String,
      fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
    );
  }

  Denuncia copyWith({
    String? id,
    String? numeroDenuncia,
    String? fecha,
    String? hora,
    String? nombreDenunciante,
    String? apellidoDenunciante,
    String? ciDenunciante,
    String? telefonoDenunciante,
    String? direccionDenunciante,
    String? profesionDenunciante,
    String? nombreDenunciado,
    String? ciDenunciado,
    String? direccionDenunciado,
    String? profesionDenunciado,
    String? hechos,
    String? lugar,
    String? zona,
    String? turno,
    List<String>? imagenes,
    String? funcionarioAsignado,
    String? funcionarioAdicional,
    String? nombreFuncionarioAsignado,
    String? nombreFuncionarioAdicional,
    String? estado,
    String? tipoDenuncia,
    DateTime? fechaRegistro,
  }) {
    return Denuncia(
      id: id ?? this.id,
      numeroDenuncia: numeroDenuncia ?? this.numeroDenuncia,
      fecha: fecha ?? this.fecha,
      hora: hora ?? this.hora,
      nombreDenunciante: nombreDenunciante ?? this.nombreDenunciante,
      apellidoDenunciante: apellidoDenunciante ?? this.apellidoDenunciante,
      ciDenunciante: ciDenunciante ?? this.ciDenunciante,
      telefonoDenunciante: telefonoDenunciante ?? this.telefonoDenunciante,
      direccionDenunciante: direccionDenunciante ?? this.direccionDenunciante,
      profesionDenunciante: profesionDenunciante ?? this.profesionDenunciante,
      nombreDenunciado: nombreDenunciado ?? this.nombreDenunciado,
      ciDenunciado: ciDenunciado ?? this.ciDenunciado,
      direccionDenunciado: direccionDenunciado ?? this.direccionDenunciado,
      profesionDenunciado: profesionDenunciado ?? this.profesionDenunciado,
      hechos: hechos ?? this.hechos,
      lugar: lugar ?? this.lugar,
      zona: zona ?? this.zona,
      turno: turno ?? this.turno,
      imagenes: imagenes ?? this.imagenes,
      funcionarioAsignado: funcionarioAsignado ?? this.funcionarioAsignado,
      funcionarioAdicional: funcionarioAdicional ?? this.funcionarioAdicional,
      nombreFuncionarioAsignado:
          nombreFuncionarioAsignado ?? this.nombreFuncionarioAsignado,
      nombreFuncionarioAdicional:
          nombreFuncionarioAdicional ?? this.nombreFuncionarioAdicional,
      estado: estado ?? this.estado,
      tipoDenuncia: tipoDenuncia ?? this.tipoDenuncia,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }
}
