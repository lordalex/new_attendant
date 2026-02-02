import 'package:knexattendant/flutter_flow/flutter_flow_theme.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:knexattendant/flutter_flow/custom_functions.dart' as functions;
import 'message_widget.dart' show MessageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MessageModel extends FlutterFlowModel<MessageWidget> {
  ///  Local state fields for this component.

  String remitent = ' ';

  String desttinatary = ' ';

  String message = ' ';

  String date = ' ';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
