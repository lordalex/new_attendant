// Automatic FlutterFlow imports
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

Future<String> bytestobase64Action(FFUploadedFile file) async {
  // Add your function code here!
  if (file.bytes == null) {
    // Manejar el caso donde el archivo no tiene bytes (puede ser un error)
    print("Error: El archivo no tiene datos binarios.");
    return ""; // O lanza una excepción, muestra un mensaje de error, etc.
  }

  Uint8List bytes = file
      .bytes!; // Usamos el operador ! para indicar que sabemos que no es nulo
  String base64String = base64Encode(bytes);
  return base64String;
}
