import 'package:dotenv/dotenv.dart' as dotenv;
import 'package:supabase/supabase.dart';

late final SupabaseClient supabase;
late final int port;
late final String corsOrigin;

void initConfig() {
  dotenv.load(); // lee .env
  final url = dotenv.env['SUPABASE_URL'];
  final key = dotenv.env['SUPABASE_SERVICE_ROLE_KEY'];
  if (url == null || key == null) {
    throw StateError('Faltan SUPABASE_URL o SUPABASE_SERVICE_ROLE_KEY en .env');
  }
  supabase = SupabaseClient(url, key);

  port = int.tryParse(dotenv.env['PORT'] ?? '') ?? 3000;
  corsOrigin = dotenv.env['CORS_ORIGIN'] ?? '*';
}
