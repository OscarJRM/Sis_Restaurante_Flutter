import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistema_restaurante/models/platos.dart';
import "../BaseDatos/conexion.dart";
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';

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
