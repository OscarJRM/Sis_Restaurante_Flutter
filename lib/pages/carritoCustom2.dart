import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:postgres/postgres.dart';
import 'package:sistema_restaurante/models/mesas.dart';
import '../models/detallePedidos.dart';
import '../BaseDatos/conexion.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';
import '../models/platos.dart';

class carritoCustom2 extends StatefulWidget {
  final DetallePedido detallePedido;
  final Plato plato;
  const carritoCustom2(
      {required this.detallePedido, required this.plato, super.key});

  @override
  State<carritoCustom2> createState() => _carritoCustom2State();
}

class _carritoCustom2State extends State<carritoCustom2> {
  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black, offset: Offset(0, 4), blurRadius: 20)
          ],
          color: Color(0xFF212325),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.plato.urlImg,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 100,
                color: Colors.grey, // Placeholder mientras carga la imagen
              ),
              errorWidget: (context, url, error) => Container(
                height: 100,
                color: Colors.grey, // Widget de error en caso de problemas
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "${widget.plato.nomPro}",
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Cantidad: ${widget.detallePedido.canProPed}",
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
                ),
                SizedBox(width: 10),
                // Nuevo botón para editar la cantidad
                GestureDetector(
                  onTap: () async {
                    int cantidad =
                        int.parse(widget.detallePedido.canProPed.toString());
                    debugPrint(cantidad.toString());
                    final String estadoPedido =
                        await obtenerEstadoPedido(context);

                    // Verifica si el estado es "ENV" para permitir editar la cantidad
                    if (estadoPedido == "ENV") {
                      final nuevaCantidad =
                          await _mostrarDialogoCantidad(context, cantidad);

                      // Verifica si la nueva cantidad es mayor o igual a 1
                      if (nuevaCantidad != null && nuevaCantidad >= 1) {
                        // Actualiza la cantidad en la base de datos
                        final conn = await DatabaseConnection.instance.openConnection();
                        await conn.execute(
                          'UPDATE DETALLE_PEDIDOS SET CAN_PRO_PED = \$1 WHERE ID_PED_PER = \$2 AND ID_PRO_PED = \$3',
                          parameters: [
                            nuevaCantidad.toString(),
                            globalState.idPed,
                            widget.plato.idPro,
                          ],
                        );
                        await conn.close();

                        // Recarga la lista de detalles del pedido
                        final conn2 = await DatabaseConnection.instance.openConnection();
                        final result = await conn2.execute(
                          "SELECT * from DETALLE_PEDIDOS WHERE ID_PED_PER = \$1",
                          parameters: [globalState.idPed],
                        );
                        List<DetallePedido> listaDetallePedido =
                            cargarDetallePedidos(result);

                        // Actualiza el estado para reflejar la nueva información
                        setState(() {
                          widget.detallePedido.canProPed =
                              nuevaCantidad.toString();
                        });
                      } else if (nuevaCantidad != null && nuevaCantidad < 1) {
                        // Muestra un mensaje indicando que la cantidad no puede ser menor a 1
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('La cantidad no puede ser menor a 1'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } else {
                      // Si el estado no es "ENV", mostrar el cuadro de diálogo solo si la nueva cantidad es mayor o igual a la actual
                      final nuevaCantidad =
                          await _mostrarDialogoCantidad(context, cantidad);

                      if (nuevaCantidad != null && nuevaCantidad >= cantidad) {
                        // Actualiza la cantidad en la base de datos
                        final conn = await DatabaseConnection.instance.openConnection();
                        await conn.execute(
                          'UPDATE DETALLE_PEDIDOS SET CAN_PRO_PED = \$1 WHERE ID_PED_PER = \$2 AND ID_PRO_PED = \$3',
                          parameters: [
                            nuevaCantidad.toString(),
                            globalState.idPed,
                            widget.plato.idPro,
                          ],
                        );
                        await conn.close();

                        // Recarga la lista de detalles del pedido
                        final conn2 = await DatabaseConnection.instance.openConnection();
                        final result = await conn2.execute(
                          "SELECT * from DETALLE_PEDIDOS WHERE ID_PED_PER = \$1",
                          parameters: [globalState.idPed],
                        );
                        List<DetallePedido> listaDetallePedido =
                            cargarDetallePedidos(result);

                        // Actualiza el estado para reflejar la nueva información
                        setState(() {
                          widget.detallePedido.canProPed =
                              nuevaCantidad.toString();
                        });
                      } else if (nuevaCantidad != null &&
                          nuevaCantidad < cantidad) {
                        // Muestra un mensaje indicando que la nueva cantidad debe ser mayor o igual a la actual
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'La nueva cantidad debe ser mayor o igual a la actual'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Center(
                      child: Icon(Icons.edit, color: Colors.white, size: 20.0),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  widget.plato.preUni,
                  style: GoogleFonts.inter(
                      color: const Color(0xFF999999),
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
            Row(
              children: [
                Builder(builder: (innercontext) {
                  return GestureDetector(
                    onTap: () async {
                      final String estadoPedido =
                          await obtenerEstadoPedido(context);
                      debugPrint(estadoPedido);

                      // Comprueba si el estado del pedido permite la eliminación del producto
                      if (estadoPedido == "PEN" ||
                          estadoPedido == "LIS" ||
                          estadoPedido == "PRE") {
                        // Muestra un mensaje indicando que no se puede borrar un producto en un pedido enviado
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'No se puede borrar un producto en un pedido enviado'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        // Realiza la eliminación del producto de DETALLE_PEDIDOS
                        final conn = await DatabaseConnection.instance.openConnection();
                        final result = await conn.execute(
                          'DELETE FROM DETALLE_PEDIDOS WHERE ID_PED_PER = \$1 AND ID_PRO_PED = \$2',
                          parameters: [globalState.idPed, widget.plato.idPro],
                        );
                        await conn.close();

                        Navigator.pushReplacementNamed(context, '/carrito');
                      }
                    },
                    child: Container(
                      height: 30,
                      width: 100,
                      decoration: const BoxDecoration(
                          color: Color(0xFFE57734),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: const Center(
                        child: Text("Borrar",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  );
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}

// Función para mostrar el AlertDialog y obtener la cantidad
Future<int?> _mostrarDialogoCantidad(
    BuildContext context, int cantidadActual) async {
  int? nuevaCantidad;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Editar Cantidad'),
        content: TextField(
          keyboardType: TextInputType.numberWithOptions(decimal: false),
          controller: TextEditingController(text: cantidadActual.toString()),
          onChanged: (value) {
            nuevaCantidad = int.tryParse(value);
            if (nuevaCantidad != null) {
              // Validación para asegurar que la cantidad sea positiva
              nuevaCantidad = nuevaCantidad! > 0 ? nuevaCantidad : null;
            }
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (nuevaCantidad != null) {
                Navigator.of(context).pop(nuevaCantidad);
              } else {
                // Muestra un mensaje de error si la cantidad no es válida
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('La cantidad debe ser mayor que 0'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Aceptar'),
          ),
        ],
      );
    },
  );

  return nuevaCantidad;
}

Future<String> obtenerEstadoPedido(BuildContext context) async {
  final conn = await DatabaseConnection.instance.openConnection();
  final globalState = Provider.of<GlobalState>(context, listen: false);
  final result = await conn.execute(
    'SELECT ID_EST_PED FROM MAESTRO_PEDIDOS WHERE ID_PED = \$1',
    parameters: [globalState.idPed],
  );

  await conn.close();

  // Devuelve el estado del pedido o un valor predeterminado si no se encuentra
  return result.isNotEmpty ? result[0][0] as String : '';
}
