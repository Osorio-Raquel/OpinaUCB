// lib/services/realtime_service.dart
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../config.dart';
import '../models/kpi.dart';

typedef KPICallback = void Function(KPIsBundle k);

class RealtimeService {
  IO.Socket? _socket;

  void connect({KPICallback? onKPIs}) {

    ///ws nodejs
   // _socket = IO.io(
    //  backendBase,
    //  IO.OptionBuilder()
    //      .setTransports(['websocket'])
    //      .enableReconnection()
    //      .build(),
    //);
    //ws fastapi
    _socket = IO.io(
  backendWsBase,
  IO.OptionBuilder()
    .setTransports(['websocket', 'polling']) // permite upgrade
    .setPath('/socket.io/')                  // <-- MUY IMPORTANTE
    .enableReconnection()
    .build(),
);
  

    _socket!.onConnect((_) {
      // Conexión lista; el server envía snapshot inicial en 'metric:update'
    });
    _socket!.onConnectError((e) {
      print("WS connect error ❌: $e");
    });

    _socket!.onError((e) {
      print("WS error ❌: $e");
    });

    _socket!.onDisconnect((_) {
      print("WS disconnected 📴");
    });

    _socket!.on('metric:update', (data) {
      try {
        if (data is Map<String, dynamic>) {
          final bundle = KPIsBundle.fromMap(data);
          onKPIs?.call(bundle);
        } else if (data is Map) {
          final bundle = KPIsBundle.fromMap(Map<String, dynamic>.from(data));
          onKPIs?.call(bundle);
        }
      } catch (e) {
        print("metric:update parse error: $e");
      }
    });
  }


  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
