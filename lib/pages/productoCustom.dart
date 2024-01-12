import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistema_restaurante/models/platos.dart';
import "../BaseDatos/conexion.dart";
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';
import 'package:sistema_restaurante/src/conexion.dart';

class productoCustom extends StatefulWidget {
  final Plato plato;
  productoCustom({required this.plato, super.key});

  @override
  State<productoCustom> createState() => _productoCustomState();
}

class _productoCustomState extends State<productoCustom> {
  bool productoAgregado = false;
  Color buttonColor = Color(0xFFE57734);
  

  @override
  void initState() {
    super.initState();
// We can't use async directly in initState, so we use a Future.delayed to schedule the task.
    Future.delayed(Duration.zero, () async {
      // Llamada a la función para verificar el estado del producto
      final agregado = await verificarProductoAgregado();
      if (mounted) {
        setState(() {
          productoAgregado = agregado;
        });
      }
    });
  }

  Future<bool> verificarProductoAgregado() async {
    final globalState =
        Provider.of<GlobalState>(context as BuildContext, listen: false);
    final conn = await DatabaseConnection.openConnection();

    final result = await conn.execute(
        'SELECT COUNT(*) FROM DETALLE_PEDIDOS WHERE ID_PED_PER = \$1 AND ID_PRO_PED = \$2',
        parameters: [globalState.idPed, widget.plato.idPro]);

    // El resultado debería ser una lista con un único valor entero
    if (result.isNotEmpty &&
        result[0][0] != null &&
        (result[0][0]! as int) > 0) {
      return true; // El producto ya está en el carrito
    } else {
      return false; // El producto no está en el carrito
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black, offset: Offset(0, 4), blurRadius: 20)
          ],
          color: Color(0xFF212325),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: widget.plato.urlImg,
            height: 100,
            width: 230,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Text(
                  widget.plato.nomPro,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.plato.idCatPer,
                  style: GoogleFonts.inter(
                      color: const Color(0xFF999999), fontSize: 12),
                ),
                Text(
                  "\$ ${widget.plato.preUni}",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                FilledButton(
                    onPressed: () async {
                      final agregado = await verificarProductoAgregado();

                      // Actualiza el estado después de que la verificación se haya completado
                      setState(() {
                        productoAgregado = agregado;
                      });

                      if (!productoAgregado) {
                        // Marca el producto como añadido al carrito
                        setState(() {
                          productoAgregado = true;
                        });

                        // Tu lógica para añadir al carrito
                        final cantidad = await _mostrarDialogoCantidad(context);
                        if (cantidad != null && cantidad > 0) {
                          // Marcar el producto como añadido al carrito
                          setState(() {
                            productoAgregado = true;
                          });
                          // Tu lógica para añadir al carrito
                          final conn =
                              await DatabaseConnection.openConnection();
                          final result1 = await conn.execute(
                            r'INSERT INTO DETALLE_PEDIDOs VALUES ($1,$2,$3,$4)',
                            parameters: [
                              globalState.idPed,
                              widget.plato.idPro,
                              "PEN",
                              cantidad,
                            ],
                          );

                          // Mostrar la notificación en el SnackBar
                          const snackBar = SnackBar(
                            content: Text('Producto añadido al carrito'),
                            backgroundColor: Color(0xFFE57734),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else {
                        // Mostrar un mensaje si el producto ya está en el carrito
                        const snackBar1 = SnackBar(
                          content: Text('El producto ya está en el carrito'),
                          backgroundColor: Color(0xFFE57734),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar1);
                      }
                    },
                    child: Text("Añadir"),
                    style: ButtonStyle(
                        mouseCursor:
                            MaterialStateProperty.all(SystemMouseCursors.click),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                        minimumSize: MaterialStateProperty.all(Size(100, 40)),
                        backgroundColor:
                            MaterialStatePropertyAll(Color(0xFFE57734))))
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Función para mostrar el AlertDialog y obtener la cantidad
Future<int?> _mostrarDialogoCantidad(BuildContext context) async {
  int? cantidad;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Ingrese la cantidad'),
        content: TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) {
            cantidad = int.tryParse(value);
            if (cantidad != null) {
              // Validación para asegurarte de que la cantidad sea mayor a 0
              cantidad = cantidad! > 0 ? cantidad : null;
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
              if (cantidad != null) {
                Navigator.of(context).pop(cantidad);
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

  return cantidad;
}
