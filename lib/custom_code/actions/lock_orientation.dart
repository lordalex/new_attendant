// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
import 'package:flutter/services.dart';

Future lockOrientation() async {
  // Add your function code here!
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
