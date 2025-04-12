import 'package:felcv/services/cubit/session_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'dart:io';
import '../models/denuncia.dart';
import '../models/usuario.dart';
import '../services/denuncia_service.dart';
import '../screens/seleccionar_ubicacion_screen.dart';

class RegistrarDenunciaScreen extends StatefulWidget {
  final Denuncia? denuncia;
  final bool modoEdicion;
  final BuildContext context;

  const RegistrarDenunciaScreen({
    super.key,
    this.denuncia,
    this.modoEdicion = false,
    required this.context,
  });

  @override
  State<RegistrarDenunciaScreen> createState() =>
      _RegistrarDenunciaScreenState();
}

class _RegistrarDenunciaScreenState extends State<RegistrarDenunciaScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _logger = Logger('RegistrarDenunciaScreen');

  // Controladores para los campos
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _ciController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _profesionController = TextEditingController();
  final TextEditingController _nombreDenunciadoController =
      TextEditingController();
  final TextEditingController _ciDenunciadoController = TextEditingController();
  final TextEditingController _direccionDenunciadoController =
      TextEditingController();
  final TextEditingController _profesionDenunciadoController =
      TextEditingController();
  final TextEditingController _hechosController = TextEditingController();
  final TextEditingController _lugarController = TextEditingController();
  final TextEditingController _zonaController = TextEditingController();
  final TextEditingController _turnoController = TextEditingController();
  final TextEditingController _siglaController = TextEditingController();
  final TextEditingController _nombreDenuncianteController =
      TextEditingController();
  final TextEditingController _apellidoDenuncianteController =
      TextEditingController();
  final TextEditingController _ciDenuncianteController =
      TextEditingController();
  final TextEditingController _telefonoDenuncianteController =
      TextEditingController();
  final TextEditingController _ubicacionController = TextEditingController();
  final TextEditingController _carnetFuncionarioController =
      TextEditingController();
  final TextEditingController _telefonoFuncionarioController =
      TextEditingController();

  String _tipoDenunciaSeleccionado = 'Violencia Física';
  String _estadoSeleccionado = 'Pendiente';
  final String _unidad = 'FELCV';
  String? _funcionarioAsignado;
  String? _funcionarioAdicional;
  String _direccionSeleccionada = '';
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  List<String> _fotos = [];
  Usuario? usuarioActual;
  Usuario? funcionarioAsignado;
  Usuario? funcionarioAdicional;

  final List<String> _tiposDenuncia = [
    'Violencia Física',
    'Violencia Psicológica',
    'Violencia Sexual',
    'Violencia Económica',
    'Feminicidio',
    'Infanticidio',
    'Otro'
  ];

  final List<String> _estados = [
    'Pendiente',
    'En Proceso',
    'Resuelta',
    'Archivada',
  ];

  final List<String> _turnos = [
    'Mañana',
    'Tarde',
    'Noche',
  ];

  final List<String> _unidades = ['FELCV'];

  @override
  void initState() {
    super.initState();
    // Cargar fecha y hora actuales
    final now = DateTime.now();
    _fechaController.text =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    _horaController.text =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    _cargarDatos();
    if (widget.modoEdicion && widget.denuncia != null) {
      _cargarDatosDenuncia();
    }
  }

  @override
  void dispose() {
    _fechaController.dispose();
    _horaController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _ciController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _profesionController.dispose();
    _nombreDenunciadoController.dispose();
    _ciDenunciadoController.dispose();
    _direccionDenunciadoController.dispose();
    _profesionDenunciadoController.dispose();
    _hechosController.dispose();
    _lugarController.dispose();
    _zonaController.dispose();
    _turnoController.dispose();
    _siglaController.dispose();
    _nombreDenuncianteController.dispose();
    _apellidoDenuncianteController.dispose();
    _ciDenuncianteController.dispose();
    _telefonoDenuncianteController.dispose();
    _ubicacionController.dispose();
    _carnetFuncionarioController.dispose();
    _telefonoFuncionarioController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    final session = widget.context.read<SessionCubit>();
    try {
      setState(() {
        _isLoading = true;
      });
      final authUsuario = session.state.usuarioActual!;
      setState(() {
        usuarioActual = usuarioActual;
        _funcionarioAsignado = authUsuario.id;
        _isLoading = false;
      });
    } catch (e) {
      _logger.severe('Error al cargar datos: $e');
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar los datos: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Reintentar',
            onPressed: _cargarDatos,
            textColor: Colors.white,
          ),
        ),
      );
    }
  }

  void _cargarDatosDenuncia() {
    final denuncia = widget.denuncia!;
    _fechaController.text = denuncia.fecha;
    _horaController.text = denuncia.hora;
    _nombreController.text = denuncia.nombreDenunciante;
    _apellidoController.text = denuncia.apellidoDenunciante;
    _ciController.text = denuncia.ciDenunciante;
    _telefonoController.text = denuncia.telefonoDenunciante;
    _direccionController.text = denuncia.direccionDenunciante;
    _profesionController.text = denuncia.profesionDenunciante;
    _nombreDenunciadoController.text = denuncia.nombreDenunciado;
    _ciDenunciadoController.text = denuncia.ciDenunciado;
    _direccionDenunciadoController.text = denuncia.direccionDenunciado;
    _profesionDenunciadoController.text = denuncia.profesionDenunciado;
    _hechosController.text = denuncia.hechos;
    _lugarController.text = denuncia.lugar;
    _zonaController.text = denuncia.zona;
    _turnoController.text = denuncia.turno;
    _tipoDenunciaSeleccionado = denuncia.tipoDenuncia;
    _estadoSeleccionado = denuncia.estado;
    _fotos = denuncia.imagenes;

    _logger.info('Funcionario asignado cargado: $_funcionarioAsignado');
  }

  Future<void> _seleccionarUbicacion() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SeleccionarUbicacionScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        _direccionSeleccionada = result['address'];
      });
    }
  }

  Future<void> _agregarFoto() async {
    if (_fotos.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Ya se ha alcanzado el límite de 5 fotos')),
      );
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _fotos.add(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al capturar la foto')),
        );
      }
    }
  }

  Future<void> _eliminarFoto(int index) async {
    setState(() {
      _fotos.removeAt(index);
    });
  }

  Future<void> _guardarDenuncia() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final session = widget.context.read<SessionCubit>();
        final denunciaService = DenunciaService();
        final usuario = session.state.usuarioActual;

        if (usuario == null) {
          throw Exception('No hay usuario autenticado');
        }

        // Asegurar que se use la fecha y hora actuales
        final now = DateTime.now();
        final fechaActual =
            '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
        final horaActual =
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

        final denuncia = Denuncia(
          id: widget.denuncia?.id ?? '',
          numeroDenuncia: widget.denuncia?.numeroDenuncia ?? '',
          fecha: widget.modoEdicion ? _fechaController.text : fechaActual,
          hora: widget.modoEdicion ? _horaController.text : horaActual,
          nombreDenunciante: _nombreController.text,
          apellidoDenunciante: _apellidoController.text,
          ciDenunciante: _ciController.text,
          telefonoDenunciante: _telefonoController.text,
          direccionDenunciante: _direccionSeleccionada.isNotEmpty
              ? _direccionSeleccionada
              : _direccionController.text,
          profesionDenunciante: _profesionController.text,
          nombreDenunciado: _nombreDenunciadoController.text,
          ciDenunciado: _ciDenunciadoController.text,
          direccionDenunciado: _direccionDenunciadoController.text,
          profesionDenunciado: _profesionDenunciadoController.text,
          hechos: _hechosController.text,
          lugar: _lugarController.text,
          zona: _zonaController.text,
          turno: _turnoController.text,
          imagenes: _fotos,
          funcionarioAsignado: usuario.id,
          funcionarioAdicional: _funcionarioAdicional ?? '',
          nombreFuncionarioAsignado:
              session.state.usuarioActual!.nombreCompleto(),
          nombreFuncionarioAdicional:
              session.state.usuarioActual!.nombreCompleto(),
          tipoDenuncia: _tipoDenunciaSeleccionado,
          estado: 'Pendiente',
          fechaRegistro: DateTime.now(),
        );

        final success = widget.modoEdicion
            ? await denunciaService.actualizarDenuncia(denuncia)
            : await denunciaService.guardarDenuncia(denuncia);

        if (mounted) {
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.modoEdicion
                      ? 'Denuncia actualizada correctamente'
                      : 'Denuncia registrada correctamente',
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, denuncia);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error al guardar la denuncia'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = context.read<SessionCubit>();
    return Scaffold(
      appBar: AppBar(
        title:
            Column(
              children: [
                Text(widget.modoEdicion ? 'Editar Denuncia' : 'Registrar Denuncia'),
                Text(session.state.usuarioActual!.nombreCompleto(), style: const TextStyle(fontSize: 12)),
              ],
            ),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _fechaController,
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  prefixIcon: Icon(Icons.calendar_today),
                  hintText: 'Fecha generada automáticamente',
                  filled: true,
                  fillColor: Color(0xFFEEEEEE),
                ),
                readOnly: true,
                enabled: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _horaController,
                decoration: const InputDecoration(
                  labelText: 'Hora',
                  prefixIcon: Icon(Icons.access_time),
                  hintText: 'Hora generada automáticamente',
                  filled: true,
                  fillColor: Color(0xFFEEEEEE),
                ),
                readOnly: true,
                enabled: false,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la hora';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Sección de datos del denunciante
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DATOS DEL DENUNCIANTE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nombreController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Denunciante o victima',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _apellidoController,
                      decoration: const InputDecoration(
                        labelText: 'Apellido del Denunciante o victima',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el apellido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ciController,
                      decoration: const InputDecoration(
                        labelText: 'CI del Denunciante o victima ',
                        prefixIcon: Icon(Icons.badge),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el CI';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _telefonoController,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono del Denunciante o victima',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el teléfono';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _profesionController,
                      decoration: const InputDecoration(
                        labelText: 'Profesión u Ocupación',
                        prefixIcon: Icon(Icons.work),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la profesión u ocupación';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _seleccionarUbicacion,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Dirección del Denunciante o victima ',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          _direccionSeleccionada.isEmpty
                              ? 'Seleccionar ubicación en el mapa para mayor precision'
                              : _direccionSeleccionada,
                          style: TextStyle(
                            color: _direccionSeleccionada.isEmpty
                                ? Colors.grey[600]
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Sección de datos del denunciado
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DATOS DEL DENUNCIADO',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nombreDenunciadoController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Denunciado',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el nombre del denunciado';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _ciDenunciadoController,
                      decoration: const InputDecoration(
                        labelText: 'CI del Denunciado',
                        prefixIcon: Icon(Icons.badge),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _direccionDenunciadoController,
                      decoration: const InputDecoration(
                        labelText: 'Dirección del Denunciado',
                        prefixIcon: Icon(Icons.location_on),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _profesionDenunciadoController,
                      decoration: const InputDecoration(
                        labelText: 'Profesión u Ocupación del Denunciado',
                        prefixIcon: Icon(Icons.work),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sección de detalles de la denuncia
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DETALLES DE LA DENUNCIA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _hechosController,
                      decoration: const InputDecoration(
                        labelText: 'Hechos',
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese los hechos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lugarController,
                      decoration: const InputDecoration(
                        labelText: 'Lugar de los hechos',
                        prefixIcon: Icon(Icons.place),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el lugar de los hechos';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _tipoDenunciaSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Denuncia',
                        prefixIcon: Icon(Icons.warning),
                      ),
                      items: _tiposDenuncia.map((String tipo) {
                        return DropdownMenuItem<String>(
                          value: tipo,
                          child: Text(tipo),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _tipoDenunciaSeleccionado = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _estadoSeleccionado,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        prefixIcon: Icon(Icons.info),
                      ),
                      items: _estados.map((String estado) {
                        return DropdownMenuItem<String>(
                          value: estado,
                          child: Text(estado),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _estadoSeleccionado = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Sección de información policial
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'INFORMACIÓN POLICIAL',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _unidad,
                      decoration: const InputDecoration(
                        labelText: 'Unidad',
                        prefixIcon: Icon(Icons.business),
                      ),
                      items: _unidades.map((String unidad) {
                        return DropdownMenuItem<String>(
                          value: unidad,
                          child: Text(unidad),
                        );
                      }).toList(),
                      onChanged: null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _zonaController,
                      decoration: const InputDecoration(
                        labelText: 'Zona',
                        prefixIcon: Icon(Icons.location_city),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la zona';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _turnoController.text.isEmpty
                          ? null
                          : _turnoController.text,
                      decoration: const InputDecoration(
                        labelText: 'Turno',
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      items: _turnos.map((String turno) {
                        return DropdownMenuItem<String>(
                          value: turno,
                          child: Text(turno),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _turnoController.text = newValue;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor seleccione el turno';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildFuncionarioAsignadoSection(session.state.usuarios),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _carnetFuncionarioController,
                      decoration: const InputDecoration(
                        labelText: 'Número de Carnet Funcionario*',
                        prefixIcon: Icon(Icons.badge),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el número de carnet';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _telefonoFuncionarioController,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono del Funcionario *',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese el teléfono';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _siglaController,
                      decoration: const InputDecoration(
                        labelText: 'Patrulla Sigla *',
                        prefixIcon: Icon(Icons.local_police),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese la sigla de la patrulla';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildMediaSection(),
              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _guardarDenuncia,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[800],
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Guardar Denuncia'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFuncionarioAsignadoSection(List<Usuario> usuarios) {
    if (usuarios.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _funcionarioAsignado,
          decoration: const InputDecoration(
            labelText: 'Funcionario Asignado',
            prefixIcon: Icon(Icons.person_pin),
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
          items: usuarios.map((funcionario) {
            return DropdownMenuItem<String>(
              value: funcionario.id,
              child: Text(funcionario.nombreCompleto()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _funcionarioAsignado = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor seleccione un funcionario';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: _funcionarioAdicional,
          decoration: const InputDecoration(
            labelText: 'Funcionario Adicional',
            prefixIcon: Icon(Icons.person_pin_outlined),
            contentPadding: EdgeInsets.symmetric(horizontal: 12),
          ),
          items: usuarios.map((funcionario) {
            return DropdownMenuItem<String>(
              value: funcionario.id,
              child: Text(funcionario.nombreCompleto()),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _funcionarioAdicional = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMediaSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.photo_library,
                  color: Colors.green[800],
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Fotos',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Fotos (${_fotos.length}/5)',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _fotos.length + 1,
                itemBuilder: (context, index) {
                  if (index == _fotos.length) {
                    return _buildAddButton(
                      onTap: _agregarFoto,
                      icon: Icons.add_a_photo,
                      label: 'Agregar Foto',
                    );
                  }
                  return _buildFotoItem(_fotos[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton({
    required VoidCallback onTap,
    required IconData icon,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.grey[600]),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFotoItem(String path) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(path),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => _eliminarFoto(_fotos.indexOf(path)),
            ),
          ),
        ],
      ),
    );
  }
}
