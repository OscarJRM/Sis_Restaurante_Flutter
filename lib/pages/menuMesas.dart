  import "package:feather_icons/feather_icons.dart";
  import "package:flutter/material.dart";
  import "package:sistema_restaurante/models/mesas.dart";
  import "package:sistema_restaurante/pages/mesas.dart";
  import 'Pedidos.dart';

  class menuMesas extends StatelessWidget {
    const menuMesas({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 26, 27, 29),
          title: Text(
            "Mesas",
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
                  child: Expanded(child: Mesas()),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
