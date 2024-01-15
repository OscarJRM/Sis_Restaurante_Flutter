// ignore_for_file: prefer_final_fields

import 'dart:convert';
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
  String json = '';
  int mesa = 0;

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

  void updateJson(String newjson) {
    json = newjson;
    notifyListeners();
  }

  void _connectSocket() {
    socket?.onConnect((data) => print('Connected'));
    socket?.onConnectError((data) => print('Error $data'));
    socket?.onDisconnect((data) => print('Disconnected'));
  }

  void updateMesa(int newmesa) {
    mesa = newmesa;

  }

  List<Plato> pedidos = [];

  void agregarPedido(Plato pedido) {
    pedidos.clear(); // Clear the list before adding a new pedido
    pedidos.add(pedido);
    notifyListeners();
  }
}
