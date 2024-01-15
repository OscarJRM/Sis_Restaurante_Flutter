// ignore_for_file: deprecated_member_use

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sistema_restaurante/pages/menuPedidos.dart';

import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
// Importa tu clase PagoEfectivo
import './pagoEfectivo.dart';
import './pagoPaypal.dart';

class MetodosPago extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              final globalState =
                  Provider.of<GlobalState>(context, listen: false);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => menuPedidos1(globalState.cedEmpAti,
                          globalState.Nom, globalState.Ape)));
            },
            icon: const Icon(FeatherIcons.arrowLeft, color: Colors.yellow)),
        title: Text(
          'Métodos de Pago',
          style: GoogleFonts.roboto(color: Colors.yellow),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black, // Fondo negro
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PagoEfectivoView()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue, // Color del botón
                onPrimary: Colors.white, // Color del texto
                padding: EdgeInsets.symmetric(vertical: 70, horizontal: 100),
              ),
              icon: const FaIcon(FontAwesomeIcons.moneyBill),
              label: Text(
                'Pagar en Efectivo',
                style: GoogleFonts.roboto(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaypalPaymentDemo()),
                );
                print('Pago con PayPal');
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Color del botón
                onPrimary: Colors.white, // Color del texto
                padding: EdgeInsets.symmetric(vertical: 70, horizontal: 100),
              ),
              icon: const FaIcon(FontAwesomeIcons.paypal),
              label: Text(
                'Pagar con PayPal',
                style: GoogleFonts.roboto(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MetodosPago(),
  ));
}
