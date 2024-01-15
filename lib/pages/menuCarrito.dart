import "dart:io";

import "package:feather_icons/feather_icons.dart";
import "package:flutter/material.dart";
import "package:sistema_restaurante/models/mesas.dart";
import "package:sistema_restaurante/pages/carrito.dart";
import "package:sistema_restaurante/pages/carrito2.dart";
import "package:sistema_restaurante/pages/mesas.dart";
import "package:sistema_restaurante/pages/wArgumentos.dart";
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'Pedidos.dart';
import '../BaseDatos/conexion.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';
import 'package:sistema_restaurante/models/platos.dart';
import 'package:sistema_restaurante/vistaFacturas/MetodosPagos.dart';

class Carrito {
  final WebSocketChannel webSocketClient;
  Carrito({required this.webSocketClient});

  Future<void> enviarMensaje() async {
    final mensaje = "{'mensaje':'actualizar_lista'}";
    //webSocketClient.send(mensaje);
  }
}

class menuCarrito extends StatefulWidget {
  @override
  State<menuCarrito> createState() => _menuCarritoState();
}

class _menuCarritoState extends State<menuCarrito> {
  /*final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

     void _sendMessage() async {
    webSocketClient.sink.add("{'mensaje':'actualizar_lista'}");
  }*/
  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context, listen: false);

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FloatingActionButton(
              onPressed: () async {
                // Lógica para el primer botón flotante
                final conn = await DatabaseConnection.instance.openConnection();

                await conn.execute(
                  r'UPDATE MAESTRO_PEDIDOS SET ID_EST_PED = $1 WHERE id_ped = $2',
                  parameters: ["PEN", globalState.idPed],
                );

                await conn.close();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Estado del pedido actualizado a "PEN"'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              backgroundColor: const Color(0xFFE57734),
              child: const Icon(FeatherIcons.send, color: Colors.black),
            ),
          ),
          FloatingActionButton(
            onPressed: () async {
              // Lógica para el segundo botón flotante (finalizar pedido)
              // Puedes realizar acciones adicionales aquí para finalizar el pedido
              final conn = await DatabaseConnection.instance.openConnection();

              final results = await conn.execute(
                'SELECT TOT_PED FROM MAESTRO_PEDIDOS WHERE ID_PED  = \$1',
                parameters: [globalState.idPed],
              );
              await conn.close();
              if (results.isNotEmpty) {
                String totalPedido = results.first[0] as String;
                final globalState =
                    Provider.of<GlobalState>(context, listen: false);
                globalState.updateTotal(totalPedido);
                // Ahora, puedes hacer lo que quieras con la variable totalPedido
                print('Total del pedido: $totalPedido');

                // También puedes enviar el totalPedido a través de Provider
              } else {
                print('No se encontró el pedido');
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MetodosPago(),
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Pedido finalizado'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(FeatherIcons.check, color: Colors.white),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 26, 27, 29),
        title: Text(
          "Carrito",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [SizedBox(width: 20.0)],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white)),
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 8, right: 10, left: 10, bottom: 44),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 44),
                child: carrito(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
