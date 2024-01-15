import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

void main() {
  runApp(const PaypalPaymentDemo());
}

class PaypalPaymentDemo extends StatelessWidget {
  const PaypalPaymentDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PaypalPaymentDemp',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => PaypalCheckoutView(
                  sandboxMode: true,
                  clientId: "AYMgb0omsVCczLsG2hCYo9ZPB7bizff_JXI25ZuO-LXKdJc8zWOxiGYr-BcSmAgoTsx0mXq4PkoTD0mt",
                  secretKey: "ECufueUM6jMOTwgwc8y7nbkm6HQ9ynzd71e45F0nTa2dbqALFYrGCbT0EQxp91yk_VMtg-POqOwtNddy",
                  transactions: const [
                    {
                      "amount": {
                        "total": '100',
                        "currency": "USD",
                        "details": {
                          "subtotal": '100',
                          "shipping": '0',
                          "shipping_discount": 0
                        }
                      },
                      "description": "The payment transaction description.",
                      // "payment_options": {
                      //   "allowed_payment_method":
                      //       "INSTANT_FUNDING_SOURCE"
                      // },
                      "item_list": {
                        "items": [
                          {
                            "name": "Apple",
                            "quantity": 4,
                            "price": '10',
                            "currency": "USD"
                          },
                          {
                            "name": "Pineapple",
                            "quantity": 5,
                            "price": '12',
                            "currency": "USD"
                          }
                        ],

                        // Optional
                        //   "shipping_address": {
                        //     "recipient_name": "Tharwat samy",
                        //     "line1": "tharwat",
                        //     "line2": "",
                        //     "city": "tharwat",
                        //     "country_code": "EG",
                        //     "postal_code": "25025",
                        //     "phone": "+00000000",
                        //     "state": "ALex"
                        //  },
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
            },
            child: const Text('Pay with paypal'),
          ),
        ),
      ),
    );
  }
}