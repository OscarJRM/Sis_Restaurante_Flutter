import 'dart:typed_data';
import 'dart:io';
import 'package:path/path.dart';

Future<Uint8List> imageToBytes(String imagePath) async {
  // Obtiene el directorio actual
  String currentDirectory = Directory.current.path;

  // Construye la ruta completa usando barras inclinadas
  String fullPath = join(currentDirectory, imagePath);

  // Lee la imagen como bytes
  File imageFile = File(fullPath);
  Uint8List imageBytes = await imageFile.readAsBytes();
  
  return imageBytes;
}

void main() async {
  String imagePath = "\\Img\\parrillada.jpeg"; // Ruta relativa desde el directorio actual

  Uint8List bytes = await imageToBytes(imagePath);

  // Hacer algo con los bytes, como enviarlos a un servidor, guardar en la base de datos, etc.
  print('Bytes de la imagen: $bytes');
}