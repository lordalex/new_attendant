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
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'q_r_code_model.dart';
export 'q_r_code_model.dart';

class QRCodeWidget extends StatefulWidget {
  const QRCodeWidget({super.key});

  static String routeName = 'QRCode';
  static String routePath = '/qRCode';

  @override
  State<QRCodeWidget> createState() => _QRCodeWidgetState();
}

class _QRCodeWidgetState extends State<QRCodeWidget> {
  late QRCodeModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => QRCodeModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      unawaited(
        () async {
          await actions.lockOrientation();
        }(),
      );
      _model.casualResultsTicket = await actions.sendjsontourl(
        '{}',
        currentJwtToken!,
        FFAppConstants.createcasualTicket,
      );
      _model.qrURL =
          '${FFAppConstants.registerphonstaticurl}?pin=${functions.tostr(functions.getkeyfromjsonstring(_model.casualResultsTicket!, 'provisionalPIN'))}';
      safeSetState(() {});
      _model.ticketNumber = functions.tostr(functions.getkeyfromjsonstring(
          _model.casualResultsTicket!, 'ticket_number'));
      safeSetState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _model.ticketNumber,
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
      _model.instantTimer0 = InstantTimer.periodic(
        duration: Duration(milliseconds: 5000),
        callback: (timer) async {
          _model.searchResultsTicketTiming = await actions.sendjsontourl(
            ' {    \"modelName\": \"Ticket\",    \"searchCriteria\": {\"ticket_number\": \"${_model.ticketNumber}\"}}',
            currentJwtToken!,
            FFAppConstants.searchURL,
          );
          if (functions.getkeyfromjsonstring(
                  'accepted',
                  functions
                      .jsontoArray(_model.searchResultsTicketTiming!)
                      .firstOrNull!) ==
              'true') {
            _model.instantTimer0?.cancel();

            context.pushNamed(
              TicketWidget.routeName,
              queryParameters: {
                'ticketID': serializeParam(
                  _model.ticketNumber,
                  ParamType.String,
                ),
              }.withoutNulls,
            );
          }
        },
        startImmediately: true,
      );
    });
  }

  @override
  void dispose() {
    // On page dispose action.
    () async {
      _model.instantTimer0?.cancel();
    }();

    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 0.28,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5A666F), Color(0xFF1B2222)],
                stops: [0.0, 1.0],
                begin: AlignmentDirectional(0.0, -1.0),
                end: AlignmentDirectional(0, 1.0),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(75.0),
                bottomRight: Radius.circular(75.0),
                topLeft: Radius.circular(0.0),
                topRight: Radius.circular(0.0),
              ),
              border: Border.all(
                color: Color(0xFF1B2222),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 80.0, 0.0, 15.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.asset(
                  'assets/images/vallet_one.png',
                  width: 80.0,
                  height: 80.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
              child: BarcodeWidget(
                data: _model.qrURL,
                barcode: Barcode.qrCode(),
                width: MediaQuery.sizeOf(context).width * 0.85,
                height: MediaQuery.sizeOf(context).height * 0.6,
                color: FlutterFlowTheme.of(context).primaryText,
                backgroundColor: Colors.transparent,
                errorBuilder: (_context, _error) => SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.85,
                  height: MediaQuery.sizeOf(context).height * 0.6,
                ),
                drawText: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
