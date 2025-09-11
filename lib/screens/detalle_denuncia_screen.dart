import 'package:felcv/core/color_palette.dart';
import 'package:felcv/services/helpers.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:io';
import '../models/denuncia.dart';
import '../services/pdf_service.dart';
import '../screens/registrar_denuncia_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class DetalleDenunciaScreen extends StatefulWidget {
  final Denuncia denuncia;

  const DetalleDenunciaScreen({
    super.key,
    required this.denuncia,
  });

  @override
  State<DetalleDenunciaScreen> createState() => _DetalleDenunciaScreenState();
}

class _DetalleDenunciaScreenState extends State<DetalleDenunciaScreen> {
  late Denuncia _denuncia;
  bool _isLoading = false;
  bool _mostrarFotos = true;

  final List<String> _estados = [
    'Pendiente',
    'En Proceso',
    'Resuelta',
    'Archivada',
  ];

  final _logger = Logger('DetalleDenunciaScreen');

  @override
  void initState() {
    super.initState();
    _denuncia = widget.denuncia;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _mostrarImagen(String url, BuildContext context) async {
    String urlSupa = await obtenerUrlSupabase(url);
    if (!context.mounted) {
      return;
    }
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.network(urlSupa),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
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
                  'Fotos Adjuntas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: Icon(
                    _mostrarFotos ? Icons.visibility_off : Icons.visibility,
                  ),
                  label:
                      Text(_mostrarFotos ? 'Ocultar Fotos' : 'Mostrar Fotos'),
                  onPressed: () {
                    setState(() {
                      _mostrarFotos = !_mostrarFotos;
                    });
                  },
                ),
              ],
            ),
            const Divider(),
            if (_denuncia.imagenes.isNotEmpty) ...[
              Row(
                children: [
                  Icon(Icons.photo, color: Colors.green[800]),
                  const SizedBox(width: 8),
                  Text(
                    'Fotos (${_denuncia.imagenes.length})',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_mostrarFotos)
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _denuncia.imagenes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: InkWell(
                            onTap: () async {
                              _mostrarImagen(
                                  _denuncia.imagenes[index], context);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: FutureBuilder<String>(
                                future: obtenerUrlSupabase(
                                    _denuncia.imagenes[index]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2)),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Center(
                                          child: Icon(Icons.broken_image)),
                                    );
                                  } else {
                                    return Image.network(
                                      snapshot.data!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image),
                                    );
                                  }
                                },
                              ),
                            )),
                      );
                    },
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lock_outline, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        'Las fotos están ocultas',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _actualizarEstado(String nuevoEstado) async {
    setState(() => _isLoading = true);

    try {
      final denunciaActualizada = Denuncia(
          id: _denuncia.id,
          numeroDenuncia: _denuncia.numeroDenuncia,
          fecha: _denuncia.fecha,
          hora: _denuncia.hora,
          nombreDenunciante: _denuncia.nombreDenunciante,
          apellidoDenunciante: _denuncia.apellidoDenunciante,
          ciDenunciante: _denuncia.ciDenunciante,
          telefonoDenunciante: _denuncia.telefonoDenunciante,
          direccionDenunciante: _denuncia.direccionDenunciante,
          profesionDenunciante: _denuncia.profesionDenunciante,
          nombreDenunciado: _denuncia.nombreDenunciado,
          ciDenunciado: _denuncia.ciDenunciado,
          direccionDenunciado: _denuncia.direccionDenunciado,
          profesionDenunciado: _denuncia.profesionDenunciado,
          hechos: _denuncia.hechos,
          lugar: _denuncia.lugar,
          zona: _denuncia.zona,
          turno: _denuncia.turno,
          imagenes: _denuncia.imagenes,
          funcionarioAsignado: _denuncia.funcionarioAsignado,
          funcionarioAdicional: _denuncia.funcionarioAdicional,
          nombreFuncionarioAsignado: _denuncia.nombreFuncionarioAsignado,
          nombreFuncionarioAdicional: _denuncia.nombreFuncionarioAdicional,
          tipoDenuncia: _denuncia.tipoDenuncia,
          estado: nuevoEstado,
          fechaRegistro: _denuncia.fechaRegistro,
          telefonoFuncionarioAdicional: _denuncia.telefonoFuncionarioAdicional,
          carnetFuncionarioAdicional: _denuncia.carnetFuncionarioAdicional,
          sigla: _denuncia.sigla,
          latitud: _denuncia.latitud,
          longitud: _denuncia.longitud);

      if (mounted) {
        setState(() => _denuncia = denunciaActualizada);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Estado actualizado a: $nuevoEstado'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar el estado'),
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

  void _mostrarDialogoActualizarEstado() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Actualizar Estado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _estados.map((estado) {
            return ListTile(
              title: Text(estado),
              leading: Radio<String>(
                value: estado,
                groupValue: _denuncia.estado,
                onChanged: (value) {
                  if (value != null) {
                    _actualizarEstado(value);
                    Navigator.pop(context);
                  }
                },
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = ColorPalette.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Denuncia'),
        backgroundColor: palette.background,
        foregroundColor: Colors.white,
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: IconButton(
              icon: const Icon(Icons.picture_as_pdf, size: 28),
              tooltip: 'Descargar PDF',
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                setState(() => _isLoading = true);

                try {
                  // Verificar permisos en dispositivos móviles (no aplica en web)
                  if (!kIsWeb) {
                    try {
                      var status = await Permission.storage.status;
                      if (!status.isGranted) {
                        status = await Permission.storage.request();
                        if (!status.isGranted) {
                          if (mounted) {
                            scaffoldMessenger.showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Se requieren permisos de almacenamiento para generar el PDF'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 4),
                              ),
                            );
                            setState(() => _isLoading = false);
                            return;
                          }
                        }
                      }

                      // Para Android 10+ intenta solicitar permiso adicional
                      if (Platform.isAndroid) {
                        try {
                          final manageStatus =
                              await Permission.manageExternalStorage.status;
                          if (!manageStatus.isGranted) {
                            await Permission.manageExternalStorage.request();
                            // Continuar incluso sin permiso - caerá en la lógica de fallback
                          }
                        } catch (e) {
                          _logger.warning(
                              'No se pudo solicitar MANAGE_EXTERNAL_STORAGE: $e');
                          // Puede que el dispositivo no soporte este permiso, continuar
                        }
                      }
                    } catch (e) {
                      _logger.warning('Error al gestionar permisos: $e');
                      // Continuar de todos modos, ya que podría estar en una plataforma que no necesita estos permisos
                    }
                  }

                  // Mostrar indicador de progreso
                  if (mounted) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                            SizedBox(width: 16),
                            Text('Preparando PDF para descarga...'),
                          ],
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }

                  // Generar PDF con el nuevo método mejorado
                  await PdfService.generateInterventionPdf(
                    data: _denuncia.toJson(),
                    onSuccess: (message) {
                      if (mounted) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      }
                    },
                    onError: (error) {
                      if (mounted) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(content: Text(error)),
                        );
                      }
                    },
                  );
                } catch (e) {
                  _logger.severe('Error inesperado al generar PDF: $e');
                  if (mounted) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text('Error inesperado: ${e.toString()}'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4),
                      ),
                    );
                  }
                } finally {
                  if (mounted) {
                    setState(() => _isLoading = false);
                  }
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildDetalleSection(),
            const SizedBox(height: 16),
            _buildDenuncianteSection(),
            const SizedBox(height: 16),
            _buildDenunciadoSection(),
            const SizedBox(height: 16),
            _buildFuncionariosSection(),
            const SizedBox(height: 16),
            _buildHechosSection(),
            if (_denuncia.imagenes.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildMediaSection(),
            ],
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 2,
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Denuncia # ${_denuncia.id}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildEstadoChip(_denuncia.estado),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _denuncia.tipoDenuncia,
              style: TextStyle(
                fontSize: 18,
                color: Colors.green[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_denuncia.nombreDenunciante} ${_denuncia.apellidoDenunciante}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoChip(String estado) {
    Color color;
    switch (estado.toLowerCase()) {
      case 'pendiente':
        color = Colors.orange;
        break;
      case 'en proceso':
        color = Colors.blue;
        break;
      case 'resuelta':
        color = Colors.green;
        break;
      case 'archivada':
        color = Colors.grey;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        estado,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildDetalleSection() {
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
                  Icons.info_outline,
                  color: Colors.green[800],
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Detalles de la Denuncia',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildDetalleRow('Número de Denuncia', _denuncia.numeroDenuncia),
            _buildDetalleRow('Fecha', _denuncia.fecha),
            _buildDetalleRow('Hora', _denuncia.hora),
            _buildDetalleRow('Tipo de Denuncia', _denuncia.tipoDenuncia),
            _buildDetalleRow('Estado', _denuncia.estado),
            _buildDetalleRow('Zona', _denuncia.zona),
            _buildDetalleRow('Turno', _denuncia.turno),
            _buildDetalleRow('Lugar', _denuncia.lugar),
          ],
        ),
      ),
    );
  }

  Widget _buildDenuncianteSection() {
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
                  Icons.person_outline,
                  color: Colors.green[800],
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Datos del Denunciante',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildDetalleRow('Nombre',
                '${_denuncia.nombreDenunciante} ${_denuncia.apellidoDenunciante}'),
            _buildDetalleRow('CI', _denuncia.ciDenunciante),
            _buildDetalleRow('Teléfono', _denuncia.telefonoDenunciante),
            _buildDetalleRow('Dirección', _denuncia.direccionDenunciante),
            _buildDetalleRow('Profesión', _denuncia.profesionDenunciante),
          ],
        ),
      ),
    );
  }

  Widget _buildDenunciadoSection() {
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
                  Icons.person_off_outlined,
                  color: Colors.green[800],
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'DENNUNCIANTE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildDetalleRow('Nombre', _denuncia.nombreDenunciado),
            _buildDetalleRow('CI', _denuncia.ciDenunciado),
            _buildDetalleRow('Dirección', _denuncia.direccionDenunciado),
            _buildDetalleRow('Profesión', _denuncia.profesionDenunciado),
          ],
        ),
      ),
    );
  }

  Widget _buildFuncionariosSection() {
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
                  Icons.badge_outlined,
                  color: Colors.green[800],
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'POLICIA QUE INTERVINO:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildDetalleRow(
                'Funcionario Principal', _denuncia.nombreFuncionarioAsignado),
            if (_denuncia.funcionarioAdicional.isNotEmpty)
              _buildDetalleRow('Funcionario Adicional',
                  _denuncia.nombreFuncionarioAdicional),
          ],
        ),
      ),
    );
  }

  Widget _buildHechosSection() {
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
                  Icons.description_outlined,
                  color: Colors.green[800],
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'BREVE DETALLE DEL HECHO:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text(_denuncia.hechos),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalleRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegistrarDenunciaScreen(
                      denuncia: _denuncia, modoEdicion: true, context: context),
                ),
              ).then((value) {
                if (value != null) {
                  setState(() {
                    _denuncia = value;
                  });
                }
              });
            },
            icon: const Icon(Icons.edit),
            label: const Text('Editar Denuncia'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _mostrarDialogoActualizarEstado,
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.update),
            label: const Text('Actualizar Estado'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
