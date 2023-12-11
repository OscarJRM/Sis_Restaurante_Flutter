import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistema_restaurante/models/mesas.dart';

class mesasCustom extends StatelessWidget {
  final Mesa mesa;
  const mesasCustom({required this.mesa, super.key});

  @override
  Widget build(BuildContext context) {
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
                    GestureDetector(
                      onTap: () {
                        
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        decoration: const BoxDecoration(
                            color: Color(0xFFE57734),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: const Center(
                          child: Text("Seleccionar",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
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
