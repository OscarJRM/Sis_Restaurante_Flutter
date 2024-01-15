import 'package:flutter/material.dart';
import '../BaseDatos/conexion.dart';
import '../models/pedidos.dart';
import 'pedidoCustom.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Pedidos extends StatefulWidget {
  const Pedidos({Key? key}) : super(key: key);

  @override
  State<Pedidos> createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  late List<Pedido> listaPedidos = [];
  late bool isFetchingData = false;

  _connectSocket() {
    final globalState = Provider.of<GlobalState>(context, listen: false);

    globalState.socket?.onConnect((data) => print('Connected+'));
    globalState.socket?.onConnectError((data) => print('Error $data'));
    globalState.socket?.onDisconnect((data) => print('Disconnected'));

    globalState.socket?.on("message", (data) {
      print(data);
      if (mounted) {
        setState(() {
          print("carga");
          _fetchData();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _connectSocket();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final globalState = Provider.of<GlobalState>(context, listen: false);
      final conn = await DatabaseConnection.instance.openConnection();
      final result = await conn.execute(
        'SELECT * from MAESTRO_PEDIDOS where CED_EMP_ATI=\$1 AND ID_EST_PED<>\$2 order by id_ped ASC',
        parameters: [globalState.cedEmpAti, 'DES'],
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
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No hay pedidos disponibles.",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Agregue una mesa para realizar un pedido.",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
