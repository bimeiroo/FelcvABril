// import 'dart:html' as html;
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_html/html.dart';

final supabase = Supabase.instance.client;

Future<dynamic> makeRpc(String fn, {Map<String, dynamic>? params}) async {
  final responsClient = await supabase.rpc(fn, params: params);
  return responsClient;
}

Future<void> uploadImage(String blobUrl, String name) async {
  try {
    final blob = await HttpRequest.request(
      blobUrl,
      responseType: 'blob',
    );

    final reader = FileReader();
    reader.readAsArrayBuffer(blob.response);

    await reader.onLoad.first;

    final data = reader.result as Uint8List;

    // Subir a Supabase desde Uint8List
    await supabase.storage.from('archivos').uploadBinary(name, data);
  } catch (e) {
    print('Error subiendo imagen: $e');
  }
}
