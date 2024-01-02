import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  IOWebSocketChannel? channel;

  WebSocketClient(
  ) {
  }

  void connect(String url,
    Map<String, String> headers,) {
      if (channel != null && channel!.closeCode == null) {
        debugPrint('YA Conectado');
        return;
      }
      debugPrint('Conectando...');
      channel = IOWebSocketChannel.connect(url, headers: headers);

      channel!.stream.listen(
        (event) {},
        onDone: () {
          debugPrint('Coneccion cerrada');
        },
        onError: (error) {
          debugPrint('Error: $error');
        },
      );
    }

  void send(String data) {
    if(channel == null || channel!.closeCode != null ){
      debugPrint('No conectado');
      return;
    }
    channel!.sink.add(data);
  }

  void disconnect() {
    if (channel == null || channel!.closeCode != null) {
      debugPrint('No conectado');
      return;
    }
    channel!.sink.close();
  }
}
