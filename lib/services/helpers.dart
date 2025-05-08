import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

String formatearFecha(String fechaString) {
  DateTime fecha = DateFormat("dd/MM/yyyy").parse(fechaString);
  String fechaFormateada = DateFormat("yyyy-MM-dd").format(fecha);
  return fechaFormateada;
}

String formatearFecha2(String fechaString) {
  DateTime fecha = DateFormat("yyyy-MM-dd").parse(fechaString);
  String fechaFormateada = DateFormat("yyyy-MM-dd").format(fecha);
  return fechaFormateada;
}

String fechaActual() {
  return DateTime.now().toIso8601String().substring(0, 10);
}

String namePath() {
  return '${DateTime.now().millisecondsSinceEpoch}.png';
}

Future<String> obtenerUrlSupabase(String path) async {
  await dotenv.load(fileName: ".env");
  String bucketUrl =
      '${dotenv.env['API_URL'].toString()}/storage/v1/object/public/archivos/';
  return "$bucketUrl$path";
}
