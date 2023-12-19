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
                    "Produto: ${widget.plato.nomPro}",
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
                      final conn = await DatabaseConnection.openConnection();

                      // Realiza la eliminación del producto de DETALLE_PEDIDOS
                      final result = await conn.execute(
                        'DELETE FROM DETALLE_PEDIDOS WHERE ID_PED_PER = \$1 AND ID_PRO_PED = \$2',
                        parameters: [globalState.idPed, widget.plato.idPro],
                      );

                      await conn.close();
                      Navigator.pushReplacementNamed(context, '/carrito');
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
