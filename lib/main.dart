import 'package:flutter/material.dart';
import 'package:sistema_restaurante/pages/menuCarrito.dart';
import 'package:sistema_restaurante/pages/menuMesas.dart';
import 'package:sistema_restaurante/pages/menuPedidos.dart';
import 'package:sistema_restaurante/pages/mesero.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';
import 'package:sistema_restaurante/services/web_socket_client.dart';
import 'package:sistema_restaurante/src/login.dart';
import 'package:sistema_restaurante/models/platos.dart';
import 'package:sistema_restaurante/VistaCocina/Vista.dart';
import 'package:web_socket_channel/io.dart';

final webSocketClient = IOWebSocketChannel.connect("ws://echo.websocket.org/");
//final carrito = Carrito(webSocketClient: webSocketClient);

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GlobalState(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context, listen: false);
    globalState.updateCedEmpAti("1850464338");

    return MaterialApp(
      title: 'Restaurante',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF212325),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/mesas': (context) => menuMesas(),
        '/menu': (context) => Mesero(),
        '/carrito': (context) => menuCarrito(),
        '/Vista': (context) => Vista(),
      },
    );
  }
}
