import 'package:flutter/material.dart';
import 'package:sistema_restaurante/pages/menuCarrito.dart';
import 'package:sistema_restaurante/pages/menuMesas.dart';
import 'package:sistema_restaurante/pages/menuPedidos.dart';
import 'package:sistema_restaurante/pages/mesero.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';

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
        '/': (context) => menuPedidos(),
        '/mesas': (context) => menuMesas(),
        '/menu': (context) => Mesero(),
        '/carrito': (context)=> menuCarrito(),
      },
    );
  }
}
