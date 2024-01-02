import 'package:flutter/material.dart';
import 'package:sistema_restaurante/services/web_socket_client.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'Pedido.dart';

class Vista extends StatefulWidget {


    
  @override
  State<Vista> createState() => _VistaState();
}

class _VistaState extends State<Vista> {
   late WebSocketChannel webSocketClient;

  @override
  void initState() {
    super.initState();
    webSocketClient = IOWebSocketChannel.connect('ws://echo.websocket.org/');
    webSocketClient.stream.listen((message) {
      print('Nuevo mensaje desde el servidor: $message');
      // Actualizar la interfaz de usuario de la cocina según sea necesario
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista de Pedidos'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Muestra la lista de pedidos
          Expanded(
            flex: 2,
            child: ListaPedidos(onPedidoTap: (pedido) {
              _mostrarProductos(context, pedido);
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarProductos(BuildContext context, Pedido pedido) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Productos del Pedido #${pedido.id}'),
          content: Container(
            width: double.maxFinite,
            child: ListaProductosPedido(pedido: pedido),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Vista(),
  ));
}
