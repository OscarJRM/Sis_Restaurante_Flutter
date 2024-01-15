import "package:feather_icons/feather_icons.dart";
import "package:flutter/material.dart";
import "package:sistema_restaurante/pages/Pedidos.dart";
import "package:sistema_restaurante/pages/wArgumentos.dart";
import 'Pedidos.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class menuPedidos1 extends StatefulWidget {
  final String _cedula;
  final String _name;
  final String _apellido;
  const menuPedidos1(this._cedula, this._name, this._apellido, {super.key});

  @override
  State<menuPedidos1> createState() => _menuPedidos1State();
}

class _menuPedidos1State extends State<menuPedidos1> {
  late IO.Socket _socket;

  _sendMessage(String pedido) {
    _socket.emit("message", {'message': pedido, 'sender': widget._name});
  }

  _connectSocket() {
    _socket.onConnect((data) => print('Connected'));
    _socket.onConnectError((data) => print('Error $data'));
    _socket.onDisconnect((data) => print('Disconnected'));
    _socket.on("message", (data) {
      print(data);
      if (mounted) {
        setState(() {
          print("carga");
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _socket = IO.io(
        'https://sistemarestaurante.webpubsub.azure.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setPath("/clients/socketio/hubs/Centro")
            .setQuery({'username': widget._cedula})
            .build());
    final globalState = Provider.of<GlobalState>(context, listen: false);
    globalState.updatesocket(_socket);
    _connectSocket();
  }

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context, listen: false);
    globalState.updateCedEmpAti(widget._cedula);
    globalState.updateNom(widget._name);
    globalState.updateApe(widget._apellido);

    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 106, right: 20),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/mesas');
          },
          backgroundColor: const Color(0xFFE57734),
          child: const Stack(
            children: [
              SizedBox(
                height: 35,
                width: 35,
                child: Icon(FeatherIcons.plus, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 26, 27, 29),
        title: Text(
          "Bienvenido ${widget._name} ${widget._apellido}",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 20.0)],
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
                child: Pedidos(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
