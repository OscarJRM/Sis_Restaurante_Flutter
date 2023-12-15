import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistema_restaurante/models/mesas.dart';
import 'package:sistema_restaurante/pages/menuPedidos.dart';
import '../BaseDatos/conexion.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';

class mesasCustom extends StatelessWidget {
  final Mesa mesa;
  final String CED_EMP_ATI;
  const mesasCustom({required this.mesa, required this.CED_EMP_ATI, super.key});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Mesa N°: ${mesa.numMes}",
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    Text(
                      mesa.estMes,
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
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Cancelar")),
                                      TextButton(
                                          onPressed: () async {
                                            final conn =
                                                await DatabaseConnection
                                                    .openConnection();
                                            final result2 = await conn.execute(
                                              r'INSERT INTO MAESTRO_PEDIDOS (FEC_HOR_PED, TOT_PED, CED_EMP_ATI, NUM_MES_PID, ID_EST_PED) VALUES (CURRENT_TIMESTAMP, 0.1, $1, $2,$3)',
                                              parameters: [
                                                CED_EMP_ATI,
                                                mesa.numMes,
                                                "PEN"
                                              ],
                                            );

                                            // Paso 2: Cambiar el estado de la mesa a "OCUPADA"
                                            final result3 = await conn.execute(
                                              r'UPDATE MESAS SET EST_MES = $1 WHERE NUM_MES = $2',
                                              parameters: [
                                                "OCUPADA",
                                                mesa.numMes
                                              ],
                                            );

                                            await conn.close();
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    menuPedidos1(
                                                        globalState.cedEmpAti,
                                                        globalState.Nom,
                                                        globalState.Ape),
                                              ),
                                            );
                                          },
                                          child: const Text("Aceptar"))
                                    ],
                                    title: const Text("Mesas"),
                                    contentPadding: const EdgeInsets.all(20),
                                    content: const Text(
                                        "¿Estas seguro de seleccionar la mesa?"),
                                  ));
                        },
                        child: Container(
                          height: 30,
                          width: 100,
                          decoration: const BoxDecoration(
                              color: Color(0xFFE57734),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                          child: const Center(
                            child: Text("Seleccionar",
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
