import "package:feather_icons/feather_icons.dart";
import "package:flutter/material.dart";
import 'productosMesero.dart';
import 'package:badges/badges.dart' as badges;

class Mesero extends StatelessWidget {
  const Mesero({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 106, right: 20),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/carrito');
          },
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
                      child: Text("", style: TextStyle(fontSize: 12)),
                      backgroundColor: Colors.white))
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 26, 27, 29),
        title: const Text(
          "Menú",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          badges.Badge(
            badgeContent: const Text(
              '',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            child: Icon(Icons.shopping_bag, color: Colors.white),
            badgeStyle: badges.BadgeStyle(
              badgeColor: Color(0xFFE57734),
            ),
          ),
          SizedBox(width: 20.0)
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white)),
      ),
      body: const Padding(
        padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 44),
        child: SingleChildScrollView(
          child: Column(
            children: [
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
