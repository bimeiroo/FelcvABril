import 'dart:io';
import 'package:felcv/services/custom_pdf.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:logging/logging.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:printing/printing.dart';
import 'package:universal_html/html.dart' as html;
import '../models/denuncia.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfService {
  static final _logger = Logger('PdfService');

  static Future<void> generateAndSavePdf({
    required String title,
    required Map<String, String> data,
  }) async {
    try {
      _logger.info('Iniciando generación de PDF: $title');

      // Crear documento PDF
      final pdf = pw.Document();

      // Añadir página con contenido
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            ...data.entries.map((entry) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 150,
                        child: pw.Text(
                          entry.key,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(entry.value),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );

      // Generar bytes del PDF
      final bytes = await pdf.save();
      _logger.info('PDF generado en memoria correctamente');

      // Guardar en un archivo
      final String fileName =
          'denuncia_${DateTime.now().millisecondsSinceEpoch}.pdf';

      // Obtener directorio para guardar
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName');

      // Escribir archivo
      await file.writeAsBytes(bytes);
      _logger.info('PDF guardado en: ${file.path}');

      // Mostrar el archivo al usuario a través de la función Share
      await Share.shareXFiles([XFile(file.path)], text: 'Denuncia PDF');
      _logger.info('PDF compartido con éxito');
    } catch (e, stackTrace) {
      _logger.severe('Error al generar PDF: $e');
      _logger.severe('Stack trace: $stackTrace');

      // Reenviar la excepción con mensaje más claro
      throw Exception(
          'Error al generar el PDF: ${e.toString()}. Por favor verifica los permisos de almacenamiento de la aplicación.');
    }
  }

  static pw.Widget _buildHeader(
      String title, pw.MemoryImage? logoImage, String numeroDenuncia) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Row(children: [
            pw.Column(
              children: [
                pw.Container(
                  width: 40,
                  height: 40,
                  child: pw.Image(logoImage!),
                ),
                pw.Text(
                  'POLICIA BOLIVIANA',
                  style: pw.TextStyle(
                    fontSize: 7,
                    fontWeight: pw.FontWeight.bold,
                    font: pw.Font.courier(),
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  'DIRECCION DEPARTAMENTAL DE LA FUERZA ESPECIAL',
                  style: pw.TextStyle(
                    fontSize: 7,
                    fontWeight: pw.FontWeight.bold,
                    font: pw.Font.courier(),
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  'DE LUCHA CONTRA LA VIOLENCIA',
                  style: pw.TextStyle(
                    fontSize: 7,
                    fontWeight: pw.FontWeight.bold,
                    font: pw.Font.courier(),
                  ),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  '“GENOVEVA RIOS”',
                  style: pw.TextStyle(
                    fontSize: 7,
                    fontWeight: pw.FontWeight.bold,
                    font: pw.Font.courier(),
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            )
          ]),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 60,
                height: 60,
                child: pw.Image(logoImage),
              ),
              pw.SizedBox(width: 10),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'POLICIA BOLIVIANA',
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                        font: pw.Font.courier(),
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'DIRECCION DEPTAL DE LA FUERZA ESPECIAL DE LUCHA CONTRA LA VIOLENCIA "GENOVEVA RIOS"',
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                        font: pw.Font.courier(),
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Cochabamba - Bolivia',
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                        font: pw.Font.courier(),
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'INFORME DE INTERVENCIÓN POLICIAL O ACCIÓN DIRECTA',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      '(Art. 293 y 295 del CPE)',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Número de Denuncia: $numeroDenuncia',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Fecha de generación: ${DateTime.now().toString().split('.')[0]}',
            style: const pw.TextStyle(
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> generatePdf(Denuncia denuncia, String? logoPath,
      Function(String) onSuccess, Function(String) onError) async {
    try {
      _logger.info(
          'Iniciando generación de PDF detallado para la denuncia: ${denuncia.numeroDenuncia}');

      // Verificar permisos solo en plataformas móviles o desktop, no en web
      if (!kIsWeb) {
        try {
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            onError(
                'Se requieren permisos de almacenamiento para generar el PDF');
            return;
          }
        } catch (e) {
          _logger.warning('Error al solicitar permisos: $e');
          // Continuar de todos modos ya que podría estar en una plataforma que no necesita permisos
        }
      }

      // Crear documento PDF
      final pdf = pw.Document();

      // Preparar datos
      final data = {
        'Número de Denuncia': denuncia.numeroDenuncia,
        'Fecha': denuncia.fecha,
        'Hora': denuncia.hora,
        'Tipo de Denuncia': denuncia.tipoDenuncia,
        'Estado': denuncia.estado,
        'Funcionario Asignado': denuncia.nombreFuncionarioAsignado,
        'Funcionario Adicional': denuncia.nombreFuncionarioAdicional.isEmpty
            ? 'No asignado'
            : denuncia.nombreFuncionarioAdicional,
        'Nombre del Denunciante':
            '${denuncia.nombreDenunciante} ${denuncia.apellidoDenunciante}',
        'CI del Denunciante': denuncia.ciDenunciante,
        'Teléfono del Denunciante': denuncia.telefonoDenunciante,
        'Dirección del Denunciante': denuncia.direccionDenunciante,
        'Profesión del Denunciante': denuncia.profesionDenunciante,
        'Nombre del Denunciado': denuncia.nombreDenunciado,
        'CI del Denunciado': denuncia.ciDenunciado,
        'Dirección del Denunciado': denuncia.direccionDenunciado,
        'Profesión del Denunciado': denuncia.profesionDenunciado,
        'Lugar': denuncia.lugar,
        'Zona': denuncia.zona,
        'Turno': denuncia.turno,
        'Hechos': denuncia.hechos,
      };

      // Añadir página con contenido
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Denuncia #${denuncia.numeroDenuncia}',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            ...data.entries.map((entry) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 8),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 150,
                        child: pw.Text(
                          entry.key,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(entry.value),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      );

      // Generar bytes del PDF
      final bytes = await pdf.save();
      _logger.info('PDF generado en memoria correctamente');

      // Si estamos en web, usar el paquete printing para la descarga directa
      if (kIsWeb) {
        try {
          _logger.info('Detectada plataforma web, usando descarga directa');
          final fileName = 'denuncia_${denuncia.numeroDenuncia}.pdf';
          await Printing.sharePdf(bytes: bytes, filename: fileName);
          onSuccess('PDF generado y listo para compartir');
          return;
        } catch (e) {
          _logger.severe('Error al compartir PDF en web: $e');
          onError('Error al compartir PDF: ${e.toString()}');
          return;
        }
      }

      // Para plataformas móviles y desktop
      final String fileName =
          'denuncia_${denuncia.numeroDenuncia}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      try {
        // Obtener directorio para guardar
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);

        // Escribir archivo
        await file.writeAsBytes(bytes);
        _logger.info('PDF guardado en: ${file.path}');

        // Compartir archivo
        await Share.shareXFiles([XFile(file.path)],
            text: 'Denuncia ${denuncia.numeroDenuncia}');

        onSuccess('PDF generado y listo para compartir');
      } catch (e) {
        _logger.severe('Error al guardar o compartir PDF: $e');

        // Intento alternativo usando flutter_file_dialog
        try {
          _logger.info('Intentando método alternativo con flutter_file_dialog');
          final params = SaveFileDialogParams(
            data: bytes,
            fileName: fileName,
          );
          final path = await FlutterFileDialog.saveFile(params: params);

          if (path != null) {
            _logger.info(
                'PDF guardado con éxito usando flutter_file_dialog en: $path');
            onSuccess('PDF guardado correctamente');
          } else {
            onError('No se pudo guardar el PDF');
          }
        } catch (dialogError) {
          _logger.severe('Error en método alternativo: $dialogError');
          onError('Error al guardar el PDF: $e');
        }
      }
    } catch (e, stackTrace) {
      _logger.severe('Error al generar PDF detallado: $e');
      _logger.severe('Stack trace: $stackTrace');

      onError('Error al generar el PDF: ${e.toString()}');
    }
  }

  Future<void> generatePdfFromDenuncia(Denuncia denuncia) async {
    try {
      _logger.info(
          'Iniciando generación de PDF para denuncia: ${denuncia.numeroDenuncia}');

      // Verificar permisos en plataformas móviles
      if (!kIsWeb) {
        try {
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            throw Exception(
                'Se requieren permisos de almacenamiento para generar el PDF');
          }
        } catch (e) {
          _logger.warning('Error al solicitar permisos: $e');
          // Continuar de todos modos ya que podría estar en una plataforma que no necesita permisos
        }
      }

      final pdf = pw.Document();
      final data = _prepararDatos(denuncia);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            _buildHeaderSection(denuncia.numeroDenuncia),
            _buildContentSection(data),
            if (!kIsWeb && denuncia.imagenes.isNotEmpty)
              _buildImagesSection(denuncia.imagenes),
            _buildSignatures(),
          ],
        ),
      );

      // Si estamos en web, usar el paquete printing para la descarga directa
      if (kIsWeb) {
        _logger.info('Detectada plataforma web, usando descarga directa');
        final fileName = 'denuncia_${denuncia.numeroDenuncia}.pdf';
        await Printing.sharePdf(bytes: await pdf.save(), filename: fileName);
        return;
      }

      final output = await _guardarPdf(pdf, denuncia.numeroDenuncia);
      _logger.info('PDF generado exitosamente: $output');

      try {
        final xFile = XFile(output);
        await Share.shareXFiles([xFile],
            text: 'Denuncia ${denuncia.numeroDenuncia}');
      } catch (shareError) {
        _logger.warning('Error al compartir PDF: $shareError');

        // Método alternativo con flutter_file_dialog
        try {
          _logger.info('Intentando método alternativo con flutter_file_dialog');
          final params = SaveFileDialogParams(
            data: await pdf.save(),
            fileName: 'denuncia_${denuncia.numeroDenuncia}.pdf',
          );
          final path = await FlutterFileDialog.saveFile(params: params);

          if (path == null) {
            throw Exception('No se pudo guardar el PDF');
          }
        } catch (dialogError) {
          _logger.severe('Error en método alternativo: $dialogError');
          throw Exception('Error al guardar o compartir el PDF: $shareError');
        }
      }
    } catch (e) {
      _logger.severe('Error al generar PDF: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _prepararDatos(Denuncia denuncia) {
    _logger.info('Preparando datos para el PDF');
    return {
      'Información General': {
        'Número de Denuncia': denuncia.numeroDenuncia,
        'Fecha de Registro': denuncia.fechaRegistro.toString(),
        'Tipo de Denuncia': denuncia.tipoDenuncia,
        'Estado': denuncia.estado,
      },
      'Información del Denunciante': {
        'Nombre': denuncia.nombreDenunciante,
        'Apellido': denuncia.apellidoDenunciante,
        'CI': denuncia.ciDenunciante,
        'Teléfono': denuncia.telefonoDenunciante,
        'Dirección': denuncia.direccionDenunciante,
        'Profesión u Ocupación': denuncia.profesionDenunciante,
      },
      'Detalles de la Denuncia': {
        'Lugar': denuncia.lugar,
        'Hechos': denuncia.hechos,
      },
      'Policías que Intervinieron': {
        'Funcionario Asignado': denuncia.nombreFuncionarioAsignado,
        'Nombre Funcionario Adicional': denuncia.nombreFuncionarioAdicional,
      },
    };
  }

  pw.Widget _buildHeaderSection(String numeroDenuncia) {
    return pw.Header(
      level: 0,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('INFORME DE INTERVENCIÓN POLICIAL',
              style:
                  pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Text('Número de Denuncia: $numeroDenuncia',
              style: const pw.TextStyle(fontSize: 14)),
          pw.Divider(),
        ],
      ),
    );
  }

  pw.Widget _buildContentSection(Map<String, dynamic> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: data.entries.map((section) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(
              level: 1,
              child: pw.Text(section.key,
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 10),
            ...(_buildSection(section.value as Map<String, dynamic>)),
            pw.SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }

  List<pw.Widget> _buildSection(Map<String, dynamic> sectionData) {
    return sectionData.entries.map((field) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 5),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('${field.key}: ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Expanded(
              child: pw.Text(field.value?.toString() ?? 'N/A'),
            ),
          ],
        ),
      );
    }).toList();
  }

  pw.Widget _buildImagesSection(List<String> imagePaths) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Header(
          level: 1,
          child: pw.Text('Evidencia Fotográfica',
              style:
                  pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
        ),
        pw.SizedBox(height: 10),
        pw.Wrap(
          spacing: 10,
          runSpacing: 10,
          children: imagePaths.map((path) {
            try {
              if (kIsWeb) {
                // No se pueden cargar imágenes locales directamente en la web
                return pw.Container(
                  width: 200,
                  height: 200,
                  child: pw.Center(
                    child: pw.Text('Imagen no disponible en modo web',
                        style: const pw.TextStyle(color: PdfColors.grey)),
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey),
                  ),
                );
              }

              final File file = File(path);
              if (!file.existsSync()) {
                _logger.warning('Archivo de imagen no encontrado: $path');
                return pw.Container(
                  width: 200,
                  height: 200,
                  child: pw.Center(
                    child: pw.Text('Imagen no encontrada',
                        style: const pw.TextStyle(color: PdfColors.grey)),
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey),
                  ),
                );
              }

              final image = pw.MemoryImage(
                file.readAsBytesSync(),
              );
              return pw.Container(
                width: 200,
                height: 200,
                child: pw.Image(image, fit: pw.BoxFit.cover),
              );
            } catch (e) {
              _logger.warning('Error al cargar imagen: $path - $e');
              return pw.Container(
                width: 200,
                height: 200,
                child: pw.Center(
                  child: pw.Text('Error al cargar imagen',
                      style: const pw.TextStyle(color: PdfColors.grey)),
                ),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey),
                ),
              );
            }
          }).toList(),
        ),
      ],
    );
  }

  pw.Widget _buildSignatures() {
    return pw.Column(
      children: [
        pw.SizedBox(height: 50),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: [
            _buildSignatureLine('Firma del Denunciante'),
            _buildSignatureLine('Firma del Funcionario'),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildSignatureLine(String title) {
    return pw.Column(
      children: [
        pw.Container(
          width: 200,
          decoration: const pw.BoxDecoration(
            border: pw.Border(bottom: pw.BorderSide(width: 1)),
          ),
          height: 1,
        ),
        pw.SizedBox(height: 5),
        pw.Text(title),
      ],
    );
  }

  Future<String> _guardarPdf(pw.Document pdf, String numeroDenuncia) async {
    try {
      final bytes = await pdf.save();
      final output = await _getOutputFilePath(numeroDenuncia);

      // Verificar si el directorio existe, si no, crearlo
      final directory = File(output).parent;
      if (!directory.existsSync()) {
        await directory.create(recursive: true);
      }

      await File(output).writeAsBytes(bytes);
      _logger.info('PDF guardado en: $output');
      return output;
    } catch (e) {
      _logger.severe('Error al guardar PDF en el dispositivo: $e');
      // Intentar usar directorio de caché como alternativa
      try {
        final directory = await getTemporaryDirectory();
        final filename =
            'denuncia_${numeroDenuncia.toLowerCase().replaceAll(' ', '_')}.pdf';
        final output = '${directory.path}/$filename';

        await File(output).writeAsBytes(await pdf.save());
        _logger.info('PDF guardado en directorio temporal: $output');
        return output;
      } catch (e2) {
        _logger.severe('Error al guardar en directorio temporal: $e2');
        throw Exception(
            'No se pudo guardar el PDF en el dispositivo. Error: $e2');
      }
    }
  }

  Future<String> _getOutputFilePath(String numeroDenuncia) async {
    try {
      if (kIsWeb) {
        throw Exception(
            'No se puede obtener ruta de archivo en plataforma web');
      }

      // Primero intentar el directorio de documentos
      final directory = await getApplicationDocumentsDirectory();
      final filename =
          'denuncia_${numeroDenuncia.toLowerCase().replaceAll(' ', '_')}.pdf';
      return '${directory.path}/$filename';
    } catch (e) {
      _logger.warning('Error al obtener directorio de documentos: $e');

      // Intentar directorio temporal como alternativa
      final directory = await getTemporaryDirectory();
      final filename =
          'denuncia_${numeroDenuncia.toLowerCase().replaceAll(' ', '_')}.pdf';
      return '${directory.path}/$filename';
    }
  }

  pw.Widget _buildFuncionariosSection(Denuncia denuncia) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Funcionarios que Intervinieron',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text('1. ${denuncia.nombreFuncionarioAsignado}'),
        if (denuncia.nombreFuncionarioAdicional.isNotEmpty) ...[
          pw.SizedBox(height: 4),
          pw.Text('2. ${denuncia.nombreFuncionarioAdicional}'),
        ],
      ],
    );
  }

  Future<void> generateAndOpenPdf(Denuncia denuncia) async {
    try {
      _logger.info('Iniciando generación de PDF');

      // Verificar permisos solo en plataformas móviles o desktop, no en web
      if (!kIsWeb) {
        try {
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            throw Exception(
                'Se requieren permisos de almacenamiento para generar el PDF');
          }
        } catch (e) {
          _logger.warning('Error al solicitar permisos: $e');
          // Continuar de todos modos ya que podría estar en una plataforma que no necesita permisos
        }
      }

      final pdf = pw.Document();
      pw.MemoryImage? logoImage;

      try {
        final logo = await rootBundle.load('assets/images/logo.png');
        logoImage = pw.MemoryImage(logo.buffer.asUint8List());
      } catch (e) {
        _logger.warning('No se pudo cargar el logo: $e');
        // Continuar sin logo
      }

      pdf.addPage(
        pw.MultiPage(
          pageTheme: const pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.all(40),
          ),
          build: (context) => [
            _buildHeader(
                denuncia.numeroDenuncia, logoImage, denuncia.numeroDenuncia),
            pw.SizedBox(height: 20),
            _buildFuncionariosSection(denuncia),
            pw.SizedBox(height: 20),
            _buildDenuncianteSection(denuncia),
            pw.SizedBox(height: 20),
            _buildDenunciadoSection(denuncia),
            pw.SizedBox(height: 20),
            _buildHechosSection(denuncia),
            pw.SizedBox(height: 20),
            _buildUbicacionSection(denuncia),
            pw.SizedBox(height: 20),
            _buildImagenesSection(denuncia),
          ],
        ),
      );

      _logger.info('PDF generado exitosamente');

      // Si estamos en web, usar el paquete printing para la descarga directa
      if (kIsWeb) {
        _logger.info('Detectada plataforma web, usando descarga directa');
        final fileName = 'denuncia_${denuncia.numeroDenuncia}.pdf';
        await Printing.sharePdf(bytes: await pdf.save(), filename: fileName);
        return;
      }

      // Para plataformas móviles y desktop
      final output = await getApplicationDocumentsDirectory();
      final fileName = 'denuncia_${denuncia.numeroDenuncia}.pdf';
      final filePath = '${output.path}/$fileName';
      final file = File(filePath);

      await file.writeAsBytes(await pdf.save());
      _logger.info('PDF guardado en: ${file.path}');

      try {
        // Compartir archivo usando share_plus
        await Share.shareXFiles([XFile(file.path)],
            text: 'Denuncia ${denuncia.numeroDenuncia}');
        _logger.info('PDF compartido con éxito');
      } catch (shareError) {
        _logger
            .warning('Error al compartir con Share.shareXFiles: $shareError');

        // Método alternativo con flutter_file_dialog
        try {
          _logger.info('Intentando método alternativo con flutter_file_dialog');
          final params = SaveFileDialogParams(
            data: await pdf.save(),
            fileName: fileName,
          );
          final path = await FlutterFileDialog.saveFile(params: params);

          if (path != null) {
            _logger.info(
                'PDF guardado con éxito usando flutter_file_dialog en: $path');
          } else {
            throw Exception('No se pudo guardar el PDF');
          }
        } catch (dialogError) {
          _logger.severe('Error en método alternativo: $dialogError');
          throw Exception('Error al guardar o compartir el PDF: $shareError');
        }
      }
    } catch (e) {
      _logger.severe('Error al generar PDF: $e');
      rethrow;
    }
  }

  pw.Widget _buildDenuncianteSection(Denuncia denuncia) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Datos del Denunciante',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text('Nombre: ${denuncia.nombreDenunciante}'),
        pw.Text('CI: ${denuncia.ciDenunciante}'),
        pw.Text('Teléfono: ${denuncia.telefonoDenunciante}'),
        pw.Text('Dirección: ${denuncia.direccionDenunciante}'),
        pw.Text('Profesión/Ocupación: ${denuncia.profesionDenunciante}'),
      ],
    );
  }

  pw.Widget _buildDenunciadoSection(Denuncia denuncia) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Datos del Denunciado',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text('Nombre: ${denuncia.nombreDenunciado}'),
        pw.Text('CI: ${denuncia.ciDenunciado}'),
        pw.Text('Dirección: ${denuncia.direccionDenunciado}'),
        pw.Text('Profesión/Ocupación: ${denuncia.profesionDenunciado}'),
      ],
    );
  }

  pw.Widget _buildHechosSection(Denuncia denuncia) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Hechos',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text(denuncia.hechos),
      ],
    );
  }

  pw.Widget _buildUbicacionSection(Denuncia denuncia) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Ubicación',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Text('Lugar: ${denuncia.lugar}'),
        pw.Text('Zona: ${denuncia.zona}'),
        pw.Text('Turno: ${denuncia.turno}'),
      ],
    );
  }

  pw.Widget _buildImagenesSection(Denuncia denuncia) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Evidencias Fotográficas',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 8),
        if (denuncia.imagenes.isEmpty)
          pw.Text('No hay imágenes adjuntas')
        else
          ...denuncia.imagenes.map((imagen) => pw.Text(imagen)),
      ],
    );
  }

  static Future<void> generateInterventionPdf({
    required Map<String, dynamic> data,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      _logger.info('Iniciando generación de PDF');

      // Cargar el logo
      final logoBytes = await rootBundle.load('assets/images/logo.png');
      final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

      // Crear el documento PDF
      final pdf = pw.Document();

      // Agregar una página
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      children: [
                        pw.Container(
                          width: 40,
                          height: 40,
                          child: pw.Image(logoImage),
                        ),
                        textoEncabezado('POLICIA BOLIVIANA'),
                        pw.Container(
                          alignment: pw.Alignment.center,
                          child: pw.Column(
                            children: [
                              textoEncabezado(
                                  'DIRECCION DEPARTAMENTAL DE LA FUERZA ESPECIAL'),
                              textoEncabezado('DE LUCHA CONTRA LA VIOLENCIA'),
                            ],
                          ),
                        ),
                        textoEncabezado('"GENOVEVA RIOS"'),
                        pw.SizedBox(width: 20),
                        textoSubrayado('Minero-Santa Cruz - Bolivia'),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            textoEncabezado('Caso  68/2024',fontSize: 10),
                          ],
                        ),
                        textoEncabezado('Dir. Dptal. de la FELCV de: MONTERO',fontSize: 10),
                        textoEncabezado('En Fecha 26/01/2024',fontSize: 10),
                      ],
                    )
                  ]),
                  pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Column(
                  children: [
                    textoTitulo('INFORME DE INTERVENCION POLICIAL PREVENTIVA'),
                    textoTitulo('ACCIOON DIRECTA'),
                  ],
                ),
              ),
              textoNormal('Arts. 293 y 298 del Código de Procedimiento Penal'),
              textoRecomendaciones(
                  'NO HAGA USO DE CLAVES, ESCRIBA CON LETRA CLARA Y LEGIBLE, LEA CUIDADOSAMENTE CADA UNO DE LOS PUNTOS; EN CASO DE DUDA SOBRE EL LLENADO DEL PRESENTE INFORME, CONSULTE CON EL INVESTIGADOR QUE RECEPCIONA EL CASO'),
              textoNegrilla('1. POLICIAS QUE INTERVINIERON'),
              textoCuadro([
                '1. ${data['nombreFuncionarioAsignado']}',
                'UNIDAD POLICIAL: FELCV - Montero',
                'Zona: ${data['zona']}',
                '2. ${data['nombreFuncionarioAdicional']}',
                'UNIDAD POLICIAL: FELCV - Montero',
                'Zona: ${data['zona']}',
              ]),
              textoNegrilla('2. INFORMACION SOBRE EL HECHO:'),
              textoCuadro([
                'Tipo de Denuncia: ${data['tipoDenuncia']}',
                'LUGAR DEL HECHO : ${data['lugar']} ',
                'FECHA: ${data['fecha']} HR.  ${data['hora']}',
                'ARMAS UTILIZADAS un cuchillo de cocina'
              ]),
              textoNegrilla('3. DENUNCIANTE O VICTIMA:'),
              textoCuadro([
                'NOMBRES: ${data['nombreDenunciante']} ${data['apellidoDenunciante']}',
                'CI: ${data['ciDenunciante']}',
                'Dirección: ${data['direccionDenunciante']}',
                'PROFESION/OCUPACION: ${data['profesionDenunciante']}',
                'Teléfono: ${data['telefonoDenunciante']}',
              ]),
              textoNegrilla('5. PERSONA A:. APREHENDIDO'),
              textoCuadro([
                'NOMBRES Y APELLIDOS: ${data['nombreDenunciado']}',
                'CI: ${data['ciDenunciado']}',
                'Dirección: ${data['direccionDenunciado']}',
                'PROFESION/OCUPACION: ${data['profesionDenunciado']}',
              ]),
              textoNegrilla('6. RESEÑA DEL CASO:'),
              textoCuadro([data['hechos']]),
            ];
          },
        ),
      );

      // Generar bytes del PDF
      final bytes = await pdf.save();
      _logger.info('PDF generado exitosamente');

      // Guardar y compartir el PDF
      if (kIsWeb) {
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute('download', 'informe_intervencion.pdf')
          ..click();
        html.Url.revokeObjectUrl(url);
        onSuccess('PDF generado y descargado exitosamente');
      } else {
        // Para móvil
        final output = await getTemporaryDirectory();
        final file = File('${output.path}/informe_intervencion.pdf');
        await file.writeAsBytes(bytes);

        final params = SaveFileDialogParams(
          sourceFilePath: file.path,
          fileName: 'informe_intervencion.pdf',
        );

        final filePath = await FlutterFileDialog.saveFile(params: params);
        if (filePath != null) {
          onSuccess('PDF guardado en: $filePath');
        } else {
          onError('Error al guardar el PDF');
        }
      }
    } catch (e, stackTrace) {
      _logger.severe('Error al generar PDF', e, stackTrace);
      onError('Error al generar el PDF: $e');
    }
  }
}
