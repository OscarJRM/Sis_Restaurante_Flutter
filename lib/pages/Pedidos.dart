import "package:flutter/material.dart";
import '../BaseDatos/conexion.dart';
import '../models/pedidos.dart';
import 'pedidoCustom.dart';

class Pedidos extends StatefulWidget {
  const Pedidos({Key? key}) : super(key: key);

  @override
  State<Pedidos> createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  late List<Pedido> listaPedidos = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final conn = await DatabaseConnection.openConnection();
    final result = await conn.execute(
        'SELECT * from MAESTRO_PEDIDOS where CED_EMP_ATI=\$1',
        parameters: ["1850464338"]);
    setState(() {
      listaPedidos = cargarPedidos(result);
    });
    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: listaPedidos != null
          ? GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 65,
                crossAxisCount: 1,
                mainAxisSpacing: 23,
                crossAxisSpacing: 24,
              ),
              itemCount: listaPedidos.length,
              itemBuilder: (context, index) {
                return pedidoCustom(pedido: listaPedidos[index]);
              },
            )
          : const CircularProgressIndicator(), // Puedes mostrar un indicador de carga mientras se obtienen los datos
    );
  }
}
