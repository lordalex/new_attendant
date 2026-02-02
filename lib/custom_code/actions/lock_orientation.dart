// Automatic FlutterFlow imports
import 'package:knexattendant/flutter_flow/flutter_flow_theme.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:knexattendant/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
import 'package:flutter/services.dart';

Future lockOrientation() async {
  // Add your function code here!
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}
