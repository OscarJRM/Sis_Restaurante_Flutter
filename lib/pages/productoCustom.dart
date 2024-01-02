import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistema_restaurante/models/platos.dart';
import "../BaseDatos/conexion.dart";
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';

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
    final globalState = Provider.of<GlobalState>(context, listen: false);
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
                        final conn = await DatabaseConnection.openConnection();
                        final result1 = await conn.execute(
                          r'INSERT INTO DETALLE_PEDIDOs VALUES ($1,$2,$3,$4)',
                          parameters: [
                            globalState.idPed,
                            widget.plato.idPro,
                            "PEN",
                            1.0
                          ],
                        );

                        // Muestra la notificación en el SnackBar
                        const snackBar = SnackBar(
                          content: Text('Producto añadido al carrito'),
                          backgroundColor: Color(0xFFE57734),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        // Muestra un mensaje o realiza alguna acción
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
                /*GestureDetector(
                  onTap: () async {
                    final agregado = await verificarProductoAgregado();

                    // Actualiza el estado después de que la verificación se haya completado
                    setState(() {
                      productoAgregado = agregado;
                    });

                    if (!productoAgregado) {
                      // Cambia temporalmente el color del botón
                      setState(() {
                        buttonColor = Color.fromARGB(255, 141, 75, 34);
                      });

                      // Agrega un pequeño retraso
                      await Future.delayed(Duration(milliseconds: 100));

                      // Restaura el color original del botón
                      setState(() {
                        buttonColor = Color(0xFFE57734);
                      });

                      // Marca el producto como añadido al carrito
                      setState(() {
                        productoAgregado = true;
                      });

                      // Tu lógica para añadir al carrito
                      final conn = await DatabaseConnection.openConnection();
                      final result1 = await conn.execute(
                        r'INSERT INTO DETALLE_PEDIDOs VALUES ($1,$2,$3)',
                        parameters: [
                          globalState.idPed,
                          widget.plato.idPro,
                          1.0
                        ],
                      );

                      // Muestra la notificación en el SnackBar
                      const snackBar = SnackBar(
                        content: Text('Producto añadido al carrito'),
                        backgroundColor: Color(0xFFE57734),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      // Muestra un mensaje o realiza alguna acción
                      const snackBar1 = SnackBar(
                        content: Text('El producto ya está en el carrito'),
                        backgroundColor: Color(0xFFE57734),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
                    }
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Center(
                      child:
                          Text("Añadir", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                )*/
              ],
            ),
          )
        ],
      ),
    );
  }
}
/*
class productoCustom extends StatelessWidget {
  final Plato plato;
  productoCustom({required this.plato, super.key});

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
            imageUrl: plato.urlImg,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              children: [
                Text(
                  plato.nomPro,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  plato.idCatPer,
                  style: GoogleFonts.inter(
                      color: const Color(0xFF999999), fontSize: 12),
                ),
                Text(
                  "\$ ${plato.preUni}",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                GestureDetector(
                  onTap: () async {
                    final conn = await DatabaseConnection.openConnection();
                    final result1 = await conn.execute(
                        r'INSERT INTO DETALLE_PEDIDOs VALUES ($1,$2,$3)',
                        parameters: [globalState.idPed, plato.idPro, 1.0]);
                    const snackBar = SnackBar(
                        content: Text('Producto añadido al carrito'),
                        backgroundColor: Color(0xFFE57734));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: const BoxDecoration(
                        color: Color(0xFFE57734),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Center(
                      child:
                          Text("Añadir", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
*/
