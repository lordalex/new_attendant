import 'package:knexattendant/auth/firebase_auth/auth_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_animations.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_theme.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_widgets.dart';
import 'package:knexattendant/flutter_flow/instant_timer.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:knexattendant/custom_code/actions/index.dart' as actions;
import 'package:knexattendant/flutter_flow/custom_functions.dart' as functions;
import 'package:knexattendant/index.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  ///  Local state fields for this page.

  bool isLoaded = false;

  int arrivalCounter = 0;

  int processigCounter = 0;

  int parkedCounter = 0;

  int departureCounter = 0;

  int completedCounter = 0;

  int periodicHandler = 0;

  int processingDepartureCounter = 0;

  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Custom Action - sendjsontourl] action in HomePage widget.
  String? ticketlistArrival;
  // Stores action output result for [Custom Action - sendjsontourl] action in HomePage widget.
  String? ticketlistProcessingArrival;
  // Stores action output result for [Custom Action - sendjsontourl] action in HomePage widget.
  String? ticketlistParked;
  // Stores action output result for [Custom Action - sendjsontourl] action in HomePage widget.
  String? ticketlistDeparture;
  // Stores action output result for [Custom Action - sendjsontourl] action in HomePage widget.
  String? ticketlistProcessingDeparture;
  // Stores action output result for [Custom Action - sendjsontourl] action in HomePage widget.
  String? ticketlistCompleted;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
