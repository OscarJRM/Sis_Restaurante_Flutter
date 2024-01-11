import 'package:flutter/material.dart';
import '../BaseDatos/conexion.dart';
import '../models/pedidos.dart';
import 'pedidoCustom.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';

class Pedidos extends StatefulWidget {
  const Pedidos({Key? key}) : super(key: key);


  @override
  State<Pedidos> createState() => _PedidosState();

  
}

class _PedidosState extends State<Pedidos> {
  late List<Pedido> listaPedidos = [];
  late bool isFetchingData = false;
  
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final globalState = Provider.of<GlobalState>(context, listen: false);
      final conn = await DatabaseConnection.openConnection();
      final result = await conn.execute(
        'SELECT * from MAESTRO_PEDIDOS where CED_EMP_ATI=\$1',
        parameters: [globalState.cedEmpAti],
      );
      setState(() {
        listaPedidos = cargarPedidos(result);
      });
      await conn.close();
    } catch (error) {
      // Manejar el error, por ejemplo, mostrar un mensaje al usuario
      print("Error al obtener datos: $error");
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      isFetchingData = true;
    });
    await _fetchData();
    setState(() {
      isFetchingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: isFetchingData
            ? const Center(child: CircularProgressIndicator())
            : listaPedidos.isNotEmpty
                ? GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }
}
