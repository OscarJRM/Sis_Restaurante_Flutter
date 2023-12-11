import "package:feather_icons/feather_icons.dart";
import 'package:sistema_restaurante/pages/carritoCustom.dart';
import '../BaseDatos/conexion.dart';
import '../models/detallePedidos.dart';
import "package:flutter/material.dart";
import 'productosMesero.dart';
import '../models/platos.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';

import 'package:badges/badges.dart' as badges;

class carrito extends StatefulWidget {
  const carrito({super.key});

  @override
  State<carrito> createState() => _carritoState();
}

class _carritoState extends State<carrito> {
  late List<DetallePedido> listaCarrito = [];
  late List<Plato> listaPlatoC = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final globalState = Provider.of<GlobalState>(context, listen: false);
    final conn = await DatabaseConnection.openConnection();
    final result = await conn.execute(
        "SELECT * FROM DETALLE_PEDIDOS where ID_PED_PER =\$1",
        parameters: [6]);
    final result2 = await conn
        .execute("SELECT * from Productos where ID_PRO=\$1", parameters: [1]);
    setState(() {
      listaCarrito = cargarDetallePedidos(result);
      listaPlatoC = Platos(result2);
    });
    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: listaCarrito != null
          ? GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 250,
                crossAxisCount: 1,
                mainAxisSpacing: 23,
                crossAxisSpacing: 24,
              ),
              itemCount: listaCarrito.length,
              itemBuilder: (context, index) {
                return carritoCustom1(
                    detallePedido: listaCarrito[index],
                    plato: listaPlatoC[index]);
              },
            )
          : const CircularProgressIndicator(), // Puedes mostrar un indicador de carga mientras se obtienen los datos
    );
  }
}
