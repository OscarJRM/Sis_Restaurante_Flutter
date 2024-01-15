import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/vGlobal.dart';
import '../BaseDatos/conexion.dart';

void main() {
  runApp(const PaypalPaymentDemo());
}

class PaypalPaymentDemo extends StatelessWidget {
  const PaypalPaymentDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaypalPaymentDemo',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: _initPaypal(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const Center(
                child: Text('Pay with PayPal'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _initPaypal(BuildContext context) async {
    final connection = await DatabaseConnection.instance.openConnection();
    final globalState = Provider.of<GlobalState>(context, listen: false);

    final resultsPlatos = await connection.execute(
      "SELECT productos.nom_pro, detalle_pedidos.can_pro_ped, productos.pre_uni_pro FROM detalle_pedidos "
      "INNER JOIN productos ON detalle_pedidos.id_pro_ped = productos.id_pro "
      "WHERE detalle_pedidos.id_ped_per = ${globalState.idPed}",
    );

    final detallesPlatos = resultsPlatos.map((detalle) {
      return [
        detalle[0],
        detalle[1],
        detalle[2],
      ];
    }).toList();

    final total = globalState.Total.toString();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,
        clientId: "",
        secretKey: "",
        transactions: [
          {
            "amount": {
              "total": total,
              "currency": "USD",
              "details": {
                "subtotal": total,
              }
            },
            "description": "Pago de la orden.",
            "item_list": {
              "items": [
                for (var detallePlato in detallesPlatos)
                  {
                    "Nombre": detallePlato[0],
                    "Cantidad": detallePlato[1],
                    "Total": (double.parse(detallePlato[1].toString()) * double.parse(detallePlato[2].toString())).toStringAsFixed(2),
                    "currency": "USD"
                  },
              ],
            }
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          log("onSuccess: $params");
          Navigator.pop(context);
        },
        onError: (error) {
          log("onError: $error");
          Navigator.pop(context);
        },
        onCancel: () {
          print('cancelled:');
          Navigator.pop(context);
        },
      ),
    ));
  }
}
