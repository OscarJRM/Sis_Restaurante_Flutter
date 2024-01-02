import 'package:flutter/material.dart';
import 'Pedido.dart';

class Vista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vista de Pedidos'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Muestra la lista de pedidos
          Expanded(
            flex: 2,
            child: ListaPedidos(onPedidoTap: (pedido) {
              _mostrarProductos(context, pedido);
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarProductos(BuildContext context, Pedido pedido) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Productos del Pedido #${pedido.id}'),
          content: Container(
            width: double.maxFinite,
            child: ListaProductosPedido(pedido: pedido),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Vista(),
  ));
}
