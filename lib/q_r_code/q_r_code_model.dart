import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'package:knexattendant/flutter_flow/instant_timer.dart';
import 'package:knexattendant/index.dart';
import 'q_r_code_widget.dart' show QRCodeWidget;
import 'package:flutter/material.dart';

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
