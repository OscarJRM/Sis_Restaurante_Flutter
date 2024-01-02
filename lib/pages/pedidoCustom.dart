import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistema_restaurante/models/platos.dart';
import 'package:sistema_restaurante/models/pedidos.dart';
import 'package:sistema_restaurante/pages/MenuPedidos2.dart';
import 'package:sistema_restaurante/pages/mesero.dart';
import 'package:sistema_restaurante/pages/wArgumentos.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';

class pedidoCustom extends StatelessWidget {
  final Pedido pedido;
  const pedidoCustom({required this.pedido, super.key});

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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "N°: ${pedido.idPed.toString()}",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    Text(
                      "Mesa: ${pedido.numMesPid}",
                      style:
                          GoogleFonts.inter(color: Colors.white, fontSize: 18),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      pedido.idEstPed == "PEN" ? "Pendiente" : pedido.idEstPed,
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
                      return FilledButton(
                          onPressed: () {
                            globalState.updateIdPed(pedido.idPed);
                            print(globalState.idPed);
                            //Navigator.pushNamed(context, '/menu');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Mesero()));
                          },
                          child: Text("Ver"),
                          style: ButtonStyle(
                              mouseCursor: MaterialStateProperty.all(
                                  SystemMouseCursors.click),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              minimumSize:
                                  MaterialStateProperty.all(Size(100, 40)),
                              backgroundColor:
                                  MaterialStatePropertyAll(Color(0xFFE57734))));
                      /*GestureDetector(
                        onTap: () {
                          globalState.updateIdPed(pedido.idPed);
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
                      );*/
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
