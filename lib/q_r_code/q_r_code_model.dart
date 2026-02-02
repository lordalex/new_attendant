import 'package:knexattendant/auth/firebase_auth/auth_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_theme.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_widgets.dart';
import 'package:knexattendant/flutter_flow/instant_timer.dart';
import 'dart:async';
import 'dart:ui';
import 'package:knexattendant/custom_code/actions/index.dart' as actions;
import 'package:knexattendant/flutter_flow/custom_functions.dart' as functions;
import 'package:knexattendant/index.dart';
import 'q_r_code_widget.dart' show QRCodeWidget;
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QRCodeModel extends FlutterFlowModel<QRCodeWidget> {
  ///  Local state fields for this page.

  bool isLoaded = false;

  int arrivalCounter = 0;

  int processigCounter = 0;

  int parkedCounter = 0;

  int departureCounter = 0;

  int completedCounter = 0;

  int periodicHandler = 0;

  int processingDepartureCounter = 0;

  String qrURL = ' ';

  String ticketNumber = ' ';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - sendjsontourl] action in QRCode widget.
  String? casualResultsTicket;
  InstantTimer? instantTimer0;
  // Stores action output result for [Custom Action - sendjsontourl] action in QRCode widget.
  String? searchResultsTicketTiming;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer0?.cancel();
  }
}
