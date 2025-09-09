// lib/services/realtime_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../config.dart';
import '../models/kpi.dart';

typedef KPICallback = void Function(KPIsBundle k);

class RealtimeService {
  IO.Socket? _socket;

  void connect({KPICallback? onKPIs}) {
    _socket = IO.io(
      backendBase,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .build(),
    );

    _socket!.onConnect((_) {
      // Conexión lista; el server envía snapshot inicial en 'metric:update'
    });

    _socket!.on('metric:update', (data) {
      if (data is Map<String, dynamic>) {
        final bundle = KPIsBundle.fromMap(data);
        onKPIs?.call(bundle);
      }
    });
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }
}
