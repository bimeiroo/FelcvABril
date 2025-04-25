class Denuncia {
  final String? id;
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
  final String telefonoFuncionarioAdicional;
  final String carnetFuncionarioAdicional;
  final String sigla;
  final String estado;
  final String tipoDenuncia;
  final String latitud;
  final String longitud;
  final DateTime fechaRegistro;

  Denuncia({
    this.id = "0",
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
    required this.telefonoFuncionarioAdicional,
    required this.carnetFuncionarioAdicional,
    required this.sigla,
    required this.latitud,
    required this.longitud,
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
      'longitud': longitud,
      'latitud': latitud,
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
      telefonoFuncionarioAdicional:
          json['telefonoFuncionarioAdicional'] as String,
      carnetFuncionarioAdicional: json['carnetFuncionarioAdicional'] as String,
      sigla: json['sigla'] as String,
      latitud: json['latitud'] as String,
      longitud: json['longitud'] as String,
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
    String? telefonoFuncionarioAdicional,
    String? carnetFuncionarioAdicional,
    String? sigla,
    String? longitud,
    String? latitud,
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
      telefonoFuncionarioAdicional:
          telefonoFuncionarioAdicional ?? this.telefonoFuncionarioAdicional,
      carnetFuncionarioAdicional:
          carnetFuncionarioAdicional ?? this.carnetFuncionarioAdicional,
      sigla: sigla ?? this.sigla,
      longitud: longitud ?? this.longitud,
      latitud: latitud ?? this.latitud,
    );
  }
}

Denuncia fromJsonDenuncia(Map<String, dynamic> json) {
  return Denuncia(
    id: json['id_denuncia'].toString(),
    numeroDenuncia: json['numero_denuncia'] ?? '',
    fecha: json['fecha'] as String,
    hora: json['hora'] as String,
    nombreDenunciante: json['nombre_denunciante'] as String,
    apellidoDenunciante: json['apellido_denunciante'] as String,
    ciDenunciante: json['ci_denunciante'] as String,
    telefonoDenunciante: json['telefono_denunciante'] as String,
    direccionDenunciante: json['direccion_denunciante'] as String,
    profesionDenunciante: json['profesion_denunciante'] as String,
    nombreDenunciado: json['nombre_denunciado'] as String,
    ciDenunciado: json['ci_denunciado'] as String,
    direccionDenunciado: json['direccion_denunciado'] as String,
    profesionDenunciado: json['profesion_denunciado'] as String,
    hechos: json['hechos'] as String,
    lugar: json['lugar'] as String,
    zona: json['zona'] as String,
    turno: json['turno'] as String,
    imagenes: (json['imagenes'] as List<dynamic>)
        .map((imagen) => imagen['url_imagen'] as String)
        .toList(),
    funcionarioAsignado: json['id_funcionario_asignado'].toString(),
    funcionarioAdicional: json['id_funcionario_adicional'].toString(),
    nombreFuncionarioAsignado: json['nombre_funcionario_asignado'] as String,
    nombreFuncionarioAdicional: json['nombre_funcionario_adicional'] as String,
    estado: json['estado'] as String,
    tipoDenuncia: json['tipo_denuncia'] as String,
    fechaRegistro: DateTime.parse(json['fecha_registro'] as String),
    telefonoFuncionarioAdicional: json['telefono_funcionario_adicional'],
    carnetFuncionarioAdicional: json['carnet_funcionario_adicional'],
    sigla: json['sigla'],
    latitud: json['latitud'] ?? '',
    longitud: json['logitud'] ?? '',
  );
}
