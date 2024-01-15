// ignore_for_file: prefer_final_fields

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_restaurante/models/platos.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GlobalState extends ChangeNotifier {
  String cedEmpAti = '';
  int idPed = 0;
  String Nom = '';
  String Ape = ''; // Agrega la nueva variable
  double Total = 0.00;
  IO.Socket? socket = null;

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

  void updatesocket(IO.Socket newsocket) {
    socket = newsocket;
  }

  List<Plato> pedidos = [];

  void agregarPedido(Plato pedido) {
    pedidos.clear(); // Clear the list before adding a new pedido
    pedidos.add(pedido);
    notifyListeners();
  }
}
