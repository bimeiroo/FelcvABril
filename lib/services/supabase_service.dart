import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<dynamic> makeRpc(String fn, {Map<String, dynamic>? params}) async {
    final responsClient = await supabase.rpc(fn, params: params);
    return responsClient;
  }