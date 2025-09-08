// bin/server.dart

import 'dart:io';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:socket_io/socket_io.dart' as sio; // 👈 alias

// IMPORTA DESDE package:<tu_nombre_paquete>/... (no con ../lib/...)
import 'package:backend_dart_kpis/config/supabase.dart';
import 'package:backend_dart_kpis/routes/formulario_routes.dart';
import 'package:backend_dart_kpis/routes/kpi_routes.dart';
import 'package:backend_dart_kpis/sockets/realtime_gateway.dart';

Future<void> main() async {
  // logs
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((r) => print('${r.level.name}: ${r.time}: ${r.message}'));

  // config & supabase
  initConfig(); // define: port, corsOrigin, supabase

  // Router HTTP
  final router = Router()
    ..get('/health', (Request _) => Response.ok('{"ok":true}', headers: {'Content-Type':'application/json'}))
    ..mount('/api/formulario', buildFormularioRouter())
    ..mount('/api/kpis', buildKpiRouter());

  // Middlewares: CORS + logs
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders(headers: {
        ACCESS_CONTROL_ALLOW_ORIGIN: corsOrigin,
        ACCESS_CONTROL_ALLOW_HEADERS: 'Origin, Content-Type, Accept',
        ACCESS_CONTROL_ALLOW_METHODS: 'GET, POST, OPTIONS',
      }))
      .addHandler(router);

  // Un solo HttpServer para HTTP + Socket.IO
  final httpServer = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('HTTP + WS escuchando en http://0.0.0.0:$port');

  // Socket.IO (usa el alias y path fijo)
  final sioServer = sio.Server();                       // 👈 antes: Server()
  sioServer.attach(httpServer, {'path': '/socket.io/'}); // 👈 path debe coincidir con Flutter
  initRealtime(sioServer);

  // Servir HTTP sobre el mismo HttpServer
  await shelf_io.serveRequests(httpServer, handler);
}
