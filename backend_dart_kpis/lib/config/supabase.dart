import 'package:dotenv/dotenv.dart'; // OJO: sin "as dotenv"
import 'package:supabase/supabase.dart';

late final SupabaseClient supabase;
late final int port;
late final String corsOrigin;

void initConfig() {
  final env = DotEnv(includePlatformEnvironment: true)..load(); // crea instancia y carga .env

  final url = env['SUPABASE_URL'];
  final key = env['SUPABASE_SERVICE_ROLE_KEY'];
  if (url == null || key == null) {
    throw StateError('Faltan SUPABASE_URL o SUPABASE_SERVICE_ROLE_KEY en .env');
  }

  supabase = SupabaseClient(url, key);

  port = int.tryParse(env['PORT'] ?? '') ?? 3000;
  corsOrigin = env['CORS_ORIGIN'] ?? '*';
}
