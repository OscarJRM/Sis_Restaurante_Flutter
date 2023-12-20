import 'package:cached_network_image/cached_network_image.dart';
import "package:feather_icons/feather_icons.dart";
import 'package:sistema_restaurante/pages/carritoCustom.dart';
import '../BaseDatos/conexion.dart';
import '../models/detallePedidos.dart';
import "package:flutter/material.dart";
import 'productosMesero.dart';
import '../models/platos.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';

class Carrito2 extends StatefulWidget {
 final List<Plato> listaPlatos;

  const Carrito2({Key? key, required this.listaPlatos}) : super(key: key);

  @override
  State<Carrito2> createState() => _Carrito2State();
}

class _Carrito2State extends State<Carrito2> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: widget.listaPlatos.map((plato) {
        return Card(
          shadowColor: Colors.black,
          color: Color(0xFF212325),
          child: ListTile(
            title: Text(plato.nomPro, style: TextStyle(color: Colors.white)),
            subtitle: Text('Precio: ${plato.preUni}', style: TextStyle(color: Colors.white38)),
            leading: CachedNetworkImage(
              imageUrl: plato.urlImg,
            ),
            trailing: Text('Cantidad: 1', style: TextStyle(color: Colors.white, fontSize: 15)),
          ),
        );
      }).toList(),
    );
  }
}
