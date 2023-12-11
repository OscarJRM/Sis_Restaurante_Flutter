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

class carritoCustom1 extends StatefulWidget {
  final DetallePedido detallePedido;
  final Plato plato;
  const carritoCustom1({required this.detallePedido, required this.plato, super.key});

  @override
  State<carritoCustom1> createState() => _carritoCustom1State();
}

class _carritoCustom1State extends State<carritoCustom1> {
  late List<Plato> listaPlatoC = [];
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final globalState = Provider.of<GlobalState>(context, listen: false);
    final conn = await DatabaseConnection.openConnection();
    final result = await conn
        .execute("SELECT * from Productos where ID_PRO=\$1", parameters: [1]);
    setState(() {
      listaPlatoC = Platos(result);
    });

    await conn.close();
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
                Text(
                  "Produto: ${widget.plato.nomPro}",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    Text(
                      "Cantidad: ${widget.detallePedido.canProPed}",
                      style:
                          GoogleFonts.inter(color: Colors.white, fontSize: 18),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      widget.detallePedido.idProPed,
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
                        onTap: () {
                          globalState.updateIdPed(globalState.idPed);
                          print(globalState.idPed);
                          Navigator.pushNamed(context, '/menu');
                        },
                        child: Container(
                          height: 30,
                          width: 100,
                          decoration: const BoxDecoration(
                              color: Color(0xFFE57734),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: const Center(
                            child: Text("Ver",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      );
                    })
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
/*
class carritoCustom extends StatelessWidget {
  final DetallePedido detallePedido;
  const carritoCustom({required this.detallePedido, super.key});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "N°: ${detallePedido.idPedPer.toString()}",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    Text(
                      "Cantidad: ${detallePedido.canProPed}",
                      style:
                          GoogleFonts.inter(color: Colors.white, fontSize: 18),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      detallePedido.idProPed,
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
                        onTap: () {
                          globalState.updateIdPed(globalState.idPed);
                          print(globalState.idPed);
                          Navigator.pushNamed(context, '/menu');
                        },
                        child: Container(
                          height: 30,
                          width: 100,
                          decoration: const BoxDecoration(
                              color: Color(0xFFE57734),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: const Center(
                            child: Text("Ver",
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      );
                    })
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

}*/
