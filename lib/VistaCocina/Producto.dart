import 'package:flutter/material.dart';
import 'package:sistema_restaurante/BaseDatos/conexion.dart';
import 'package:sistema_restaurante/models/pedidos.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Producto {
  String id;
  String nombre;
  double precio;
  String descripcion;
  String imagenUrl;
  String estado;
  int idPedidoPertenece;
  int cantidad;

  Producto(
      {required this.id,
      required this.nombre,
      required this.precio,
      required this.descripcion,
      required this.imagenUrl,
      required this.estado,
      required this.idPedidoPertenece,
      required this.cantidad});
}

class ProductoWidget extends StatefulWidget {
  final Producto producto;

  ProductoWidget({required this.producto});

  @override
  _ProductoWidgetState createState() => _ProductoWidgetState();
}

class _ProductoWidgetState extends State<ProductoWidget> {
  late String estado =
      _estadoProducto(widget.producto.estado); // Estado inicial

  _sendMessage(String cedula, String pedido, int idPed, String nombre, int mesa,
      IO.Socket? _socket) {
    _socket?.emit("mesero", {
      'message': pedido,
      'cedEmp': cedula,
      'idPed': idPed,
      'nombre': nombre,
      'mesa': mesa
    });
  }

  _sendMessage2(String cedula, String pedido, int idPed, String nombre,
      int mesa, IO.Socket? _socket) {
    _socket?.emit("message", {
      'message': pedido,
      'cedEmp': cedula,
      'idPed': idPed,
      'nombre': nombre,
      'mesa': mesa
    });
  }

  String _estadoProducto(String est) {
    if (est == "PEN") {
      return "Espera";
    } else if (est == "PRE") {
      return "Preparando";
    } else {
      return "Listo";
    }
  }

  Future<void> cambiarEstado(
      String estadoProducto, int pedido, String producto) async {
    try {
      final connection = await DatabaseConnection.instance.openConnection();
      if (estadoProducto == "Preparando") {
        await connection.execute(
            "UPDATE detalle_pedidos SET est_pro_ped='PRE' WHERE id_ped_per= $pedido AND id_pro_ped='$producto'");
      } else if (estadoProducto == "Listo") {
        await connection.execute(
            "UPDATE detalle_pedidos SET est_pro_ped='LIS' WHERE id_ped_per= $pedido AND id_pro_ped= '$producto';");
      }
    } catch (e) {}
    //await connection.close();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 129, 116, 116).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(widget.producto.imagenUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.producto.nombre} (Cantidad: ${widget.producto.cantidad})',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Precio: \$${widget.producto.precio.toString()}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Descripción: ${widget.producto.descripcion}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Cambiar el estado del producto
                  setState(() {
                    final globalState =
                        Provider.of<GlobalState>(context, listen: false);
                    if (estado == 'Espera') {
                      estado = 'Preparando';
                      cambiarEstado(estado, widget.producto.idPedidoPertenece,
                          widget.producto.id.toString());
                    } else if (estado == 'Preparando') {
                      estado = 'Listo';
                      cambiarEstado(estado, widget.producto.idPedidoPertenece,
                          widget.producto.id);
                    } else {
                      estado = 'Listo';
                    }
                    _sendMessage(
                        globalState.cedEmpAti,
                        estado,
                        widget.producto.idPedidoPertenece,
                        widget.producto.nombre,
                        globalState.mesa,
                        globalState.socket);
                    _sendMessage2(
                        globalState.cedEmpAti,
                        estado,
                        widget.producto.idPedidoPertenece,
                        widget.producto.nombre,
                        globalState.mesa,
                        globalState.socket);

                    print('Estado actual del producto: $estado');
                  });
                },
                child: Text('Cambiar Estado: $estado'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListaProductos extends StatefulWidget {
  final List<Producto> productos;

  ListaProductos({required this.productos});

  @override
  // ignore: library_private_types_in_public_api
  _ListaProductosState createState() => _ListaProductosState();
}

class _ListaProductosState extends State<ListaProductos> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.productos.length,
      itemBuilder: (context, index) {
        return ProductoWidget(producto: widget.productos[index]);
      },
    );
  }
}
