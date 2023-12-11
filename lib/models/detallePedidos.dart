import 'package:postgres/postgres.dart';
import '../BaseDatos/conexion.dart';

class DetallePedido {
  late final int? idPed;
  final String? productId;
  final String? productName; // Cambiado a double
  final String? initalPrice;
  final String? productPrice;
  final String? quantity;
  final String? unitTag;
  final String? image;

  DetallePedido({
    required this.idPed,
    required this.productId,
    required this.productName,
    required this.initalPrice,
    required this.productPrice,
    required this.quantity,
    required this.unitTag,
    required this.image
  });
  DetallePedido.fromMap(Map<dynamic, dynamic> res)
  : idPed = res['idPed'],
  productId = res['productId'],
  productName = res['productName'],
  initalPrice = res['initalPrice'],
  productPrice= res["productPrice"],
  quantity= res["quantity"],
  unitTag = res["unitTag"],
  image = res["image"];

  Map<String, Object?> toMap(){
    return{
      'idPed': idPed,
      'productId': productId,
      'productName': productName,
      "initalPrice": initalPrice,
      "productPrice": productPrice,
      "quantity": quantity,
      "unitTag": unitTag,
      "image": image
    };
  }
}


