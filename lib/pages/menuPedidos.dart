import "package:feather_icons/feather_icons.dart";
import "package:flutter/material.dart";
import "package:sistema_restaurante/pages/Pedidos.dart";
import 'Pedidos.dart';

class menuPedidos extends StatelessWidget {
  const menuPedidos({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 106, right: 20),
        child: FloatingActionButton(
          onPressed: () {},
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
          "Menú Pedidos",
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
                child: Expanded(child: Pedidos()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
