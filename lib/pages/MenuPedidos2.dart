import "package:flutter/material.dart";
import '../models/categorias.dart';

class MenuPedidos2 extends StatefulWidget {
  const MenuPedidos2({super.key});

  @override
  State<MenuPedidos2> createState() => _MenuPedidos2State();
}

class _MenuPedidos2State extends State<MenuPedidos2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 26, 27, 29),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white),
        title: const Text(
          'Menú',
        ),
        centerTitle: true,
        // Return null if _tabController is null
      ),
    );
  }
}
