import "package:feather_icons/feather_icons.dart";
import "package:flutter/material.dart";
import "package:sistema_restaurante/models/mesas.dart";
import "package:sistema_restaurante/pages/carrito.dart";
import "package:sistema_restaurante/pages/carrito2.dart";
import "package:sistema_restaurante/pages/mesas.dart";
import "package:sistema_restaurante/pages/wArgumentos.dart";
import 'Pedidos.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';
import 'package:sistema_restaurante/models/platos.dart';

class menuCarrito extends StatelessWidget {
  const menuCarrito({super.key});

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context, listen: false);

    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 106, right: 20),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Carrito2(listaPlatos: globalState.pedidos)));
            },
            backgroundColor: const Color(0xFFE57734),
            child: const Stack(
              children: [
                SizedBox(
                  height: 35,
                  width: 35,
                  child: Icon(FeatherIcons.send, color: Colors.black),
                ),
              ],
            ),
          ),
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
        body:
            carrito() /*Carrito2(listaPlatos: globalState.pedidos)const Padding(
        padding: EdgeInsets.only(top: 8, right: 10, left: 10, bottom: 44),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 44),
                child: Carrito2(),
              )
            ],
          ),
        ),
      ),*/
        );
  }
}
