import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/platos.dart';

class GlobalState extends ChangeNotifier {
  String cedEmpAti = '';
  int idPed = 0;
  String Nom = '';
  String Ape = ''; // Agrega la nueva variable
  double Total = 0.00;

  void updateCedEmpAti(String newCedEmpAti) {
    cedEmpAti = newCedEmpAti;
  }

  void updateIdPed(int newIdPed) {
    idPed = newIdPed;
    notifyListeners();
  }

  void updateNom(String newNom) {
    Nom = newNom;
  }

  void updateApe(String newApe) {
    Ape = newApe;
  }

  void updateTotal(String newTotal) {
    Total = double.parse(newTotal);
  }

  List<Plato> pedidos = [];

  void agregarPedido(Plato pedido) {
    pedidos.clear(); // Clear the list before adding a new pedido
    pedidos.add(pedido);
    notifyListeners();
  }
}
