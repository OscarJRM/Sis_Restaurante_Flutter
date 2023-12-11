import "package:feather_icons/feather_icons.dart";
import "package:flutter/material.dart";
import 'productosMesero.dart';

class Mesero extends StatelessWidget {
  const Mesero({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 106, right: 20),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFE57734),
          child: const Stack(
            children: [
              SizedBox(
                height: 35,
                width: 35,
                child: Icon(FeatherIcons.shoppingCart),
              ),
              Positioned(
                  top: 1,
                  right: 1,
                  child: CircleAvatar(
                      radius: 8,
                      child: Text("4", style: TextStyle(fontSize: 12)),
                      backgroundColor: Colors.white))
            ],
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 44, right: 16, left: 16, bottom: 44),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back, color: Colors.white),
                  Row(
                    children: [
                      Icon(
                        FeatherIcons.search,
                        color: Colors.white,
                      ),
                      SizedBox(width: 16),
                      Icon(
                        FeatherIcons.heart,
                        color: Colors.white,
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 44),
                child: Expanded(child: ProductosMesero()),
              )
            ],
          ),
        ),
      ),
    );
  }
}
