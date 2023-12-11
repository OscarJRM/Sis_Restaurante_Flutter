import 'package:flutter/material.dart';
import 'package:sistema_restaurante/pages/menuMesas.dart';
import 'package:sistema_restaurante/pages/menuPedidos.dart';
import 'package:sistema_restaurante/pages/mesero.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        '/menu': (context) => Mesero()
      },
    );
  }
}
