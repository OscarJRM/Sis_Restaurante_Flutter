// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:sistema_restaurante/services/web_socket_client.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'Pedido.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Vista extends StatefulWidget {
  const Vista({super.key});

  @override
  State<Vista> createState() => _VistaState();
}

class _VistaState extends State<Vista> {
  late IO.Socket _socket;

  _sendMessage(String pedido) {
    _socket.emit('message', {'message': pedido, 'sender': "cocina"});
  }

  _connectSocket() {
    _socket.onConnect((data) => print('Connected'));
    _socket.onConnectError((data) => print('Error $data'));
    _socket.onDisconnect((data) => print('Disconnected'));

    _socket.on("message", (data) => print(data));
  }

  @override
  void initState() {
    super.initState();
    _socket = IO.io(
        'https://sistemarestaurante.webpubsub.azure.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setPath("/clients/socketio/hubs/Centro")
            .setQuery({'username': "cocina"})
            .build());
    _connectSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista de Pedidos'),
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
          content: SizedBox(
            width: double.maxFinite,
            child: ListaProductosPedido(pedido: pedido),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Vista(),
  ));
}
