import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'slidable_tile_ticket_list_processing_model.dart';
export 'slidable_tile_ticket_list_processing_model.dart';
import '../../../models/ticket_model.dart';
import '../../../services/vehicle_service.dart';

class SlidableTileTicketListProcessingWidget extends StatefulWidget {
  const SlidableTileTicketListProcessingWidget({
    super.key,
    this.name,
    this.plate,
    this.profileImg,
    this.departureHour,
    required this.callback,
    Color? timeTextColor,
    required this.ticketNumber,
    int? timerTimeIntegerMs,
    String? vehicleInfo,
    required this.pin,
    required this.date,
    this.ticketJson,
    this.apiUrl,
    this.idToken,
  })  : timeTextColor = timeTextColor ?? const Color(0xFF57636C),
        timerTimeIntegerMs = timerTimeIntegerMs ?? 0,
        vehicleInfo = vehicleInfo ?? ' ';

  final String? name;
  final String? plate;
  final String? profileImg;
  final String? departureHour;
  final Future Function()? callback;
  final Color timeTextColor;
  final String? ticketNumber;
  final int timerTimeIntegerMs;
  final String vehicleInfo;
  final String? pin;
  final String? date;
  final String? ticketJson;
  final String? apiUrl;
  final String? idToken;

  @override
  State<SlidableTileTicketListProcessingWidget> createState() =>
      _SlidableTileTicketListProcessingWidgetState();
}

class _SlidableTileTicketListProcessingWidgetState
    extends State<SlidableTileTicketListProcessingWidget>
    with TickerProviderStateMixin {
  late SlidableTileTicketListProcessingModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model =
        createModel(context, () => SlidableTileTicketListProcessingModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // NEW: Parse ticket JSON and fetch vehicle data
      if (widget.ticketJson != null && widget.ticketJson!.isNotEmpty) {
        try {
          print("[SlidableTile] Parsing ticket JSON");
          _model.ticket = Ticket.fromJson(widget.ticketJson!);

          // Calculate time difference
          _model.timeDifferenceText = _model.ticket!.timeDifference;
          print("[SlidableTile] Time difference: ${_model.timeDifferenceText}");

          // Load client photo safely
          if (_model.ticket!.hasClientPhoto) {
            print("[SlidableTile] Loading client photo");
            _model.clientPhoto = await actions.base64toBytesAction(
              _model.ticket!.clientPhotoUrl!,
              'clientPhoto',
            );
          }

          // Fetch vehicle data if available
          if (widget.apiUrl != null &&
              widget.idToken != null &&
              _model.ticket!.vehicle.isNotEmpty) {
            print("[SlidableTile] Fetching vehicle data");
            final vehicleService = VehicleService(
              apiUrl: widget.apiUrl!,
              idToken: widget.idToken!,
            );

            final vehicleData = await vehicleService
                .fetchVehicleDetails(_model.ticket!.vehicle);
            if (vehicleData != null) {
              print("[SlidableTile] Vehicle data loaded");
              _model.ticket = _model.ticket!.copyWith(vehicleData: vehicleData);
              _model.vehicleDisplayText = _model.ticket!.formattedVehicle;
            } else {
              _model.vehicleDisplayText = widget.vehicleInfo != ' '
                  ? widget.vehicleInfo
                  : "Vehicle info unavailable";
            }
          } else {
            _model.vehicleDisplayText = widget.vehicleInfo != ' '
                ? widget.vehicleInfo
                : "Vehicle info unavailable";
          }

          _model.isLoadingVehicle = false;
          safeSetState(() {});
        } catch (e) {
          print("[SlidableTile] Error: $e");
          _model.isLoadingVehicle = false;
          _model.vehicleDisplayText = widget.vehicleInfo != ' '
              ? widget.vehicleInfo
              : "Vehicle info unavailable";
        }
      } else {
        // Legacy mode - use existing logic
        _model.isLoadingVehicle = false;
        _model.vehicleDisplayText = widget.vehicleInfo != ' '
            ? widget.vehicleInfo
            : "Vehicle info unavailable";
      }
      _model.timerController.timer.setPresetTime(
        mSec: widget.timerTimeIntegerMs,
        add: false,
      );
      _model.timerController.onResetTimer();

      _model.timerController.onStartTimer();
      _model.posx = 0.0;
      _model.updatePage(() {});
      // Only load from profileImg if ticket JSON didn't already load a photo
      if (_model.clientPhoto == null || (_model.clientPhoto?.bytes?.isEmpty ?? true)) {
        if (widget.profileImg != null && widget.profileImg != '' && widget.profileImg != 'error') {
          _model.clientPhoto = await actions.base64toBytesAction(
            widget.profileImg!,
            'clientPhoto',
          );
        }
      }
      safeSetState(() {});
    });

    animationsMap.addAll({
      'containerOnActionTriggerAnimation': AnimationInfo(
        trigger: AnimationTrigger.onActionTrigger,
        applyInitialState: true,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.elasticOut,
            delay: 0.0.ms,
            duration: 900.0.ms,
            begin: const Offset(0.0, 0.0),
            end: const Offset(-100.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 200.0.ms,
            begin: 1.0,
            end: 0.0,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) async {
        if (details.delta.dx < 0.36) {
          FFAppState().update(() {});
          if (animationsMap['containerOnActionTriggerAnimation'] != null) {
            await animationsMap['containerOnActionTriggerAnimation']!
                .controller
                .forward();
          }
          await Future.delayed(
            const Duration(
              milliseconds: 150,
            ),
          );
          await widget.callback?.call();
          FFAppState().isTicketOn = true;
          FFAppState().ticketNumber = widget.ticketNumber!;
          safeSetState(() {});
        }
        _model.posx = details.localPosition.dx;
        safeSetState(() {});
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      15.0, 10.0, 15.0, 15.0),
                  child: Container(
                    width: 70.0,
                    height: 70.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: (_model.clientPhoto?.bytes != null &&
                              _model.clientPhoto!.bytes!.isNotEmpty)
                          ? Image.memory(
                              _model.clientPhoto!.bytes!,
                              width: 70.0,
                              height: 70.0,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/error_image.png',
                                width: 70.0,
                                height: 70.0,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.asset(
                              'assets/images/image-default.jpg',
                              width: 70.0,
                              height: 70.0,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 7.0, 5.0, 7.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-1.0, 0.0),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    widget.date,
                                    'No Date',
                                  ),
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.roboto(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        fontSize: 13.5,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                                Align(
                                  alignment:
                                      const AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 18.0, 0.0, 0.0),
                                    child: Text(
                                      '${widget.name}',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .secondary,
                                            fontSize: 16.0,
                                            letterSpacing: 2.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ),
                                // Display time difference
                                if (_model.timeDifferenceText != null)
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 4.0, 0.0, 0.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 2.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Text(
                                        _model.timeDifferenceText!,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    ),
                                  ),
                                // Display vehicle info
                                if (_model.vehicleDisplayText != null)
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 4.0, 0.0, 0.0),
                                    child: Row(
                                      children: [
                                        Icon(Icons.directions_car,
                                            size: 14.0,
                                            color: Colors.grey[600]),
                                        const SizedBox(width: 4.0),
                                        Expanded(
                                          child: Text(
                                            _model.isLoadingVehicle
                                                ? "Loading vehicle..."
                                                : _model.vehicleDisplayText!,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: _model.isLoadingVehicle
                                                  ? Colors.grey[500]
                                                  : Colors.grey[800],
                                              fontStyle: _model.isLoadingVehicle
                                                  ? FontStyle.italic
                                                  : FontStyle.normal,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 130.0,
                  child: Align(
                    alignment: const AlignmentDirectional(1.0, 0.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          0.0, 0.0, 5.0, 0.0),
                      child: Container(
                        width: 120.0,
                        decoration: const BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidClock,
                              color: valueOrDefault<Color>(
                                widget.timerTimeIntegerMs >= 300000
                                    ? const Color(0xFFA50707)
                                    : FlutterFlowTheme.of(context).primaryText,
                                FlutterFlowTheme.of(context).primary,
                              ),
                              size: 18.0,
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5.0, 0.0, 0.0, 0.0),
                                  child: FlutterFlowTimer(
                                    initialTime: _model.timerInitialTimeMs,
                                    getDisplayTime: (value) =>
                                        StopWatchTimer.getDisplayTime(
                                      value,
                                      hours: false,
                                      milliSecond: false,
                                    ),
                                    controller: _model.timerController,
                                    updateStateInterval:
                                        const Duration(milliseconds: 1000),
                                    onChanged:
                                        (value, displayTime, shouldUpdate) {
                                      _model.timerMilliseconds = value;
                                      _model.timerValue = displayTime;
                                      if (shouldUpdate) safeSetState(() {});
                                    },
                                    textAlign: TextAlign.start,
                                    style: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .override(
                                          fontFamily:
                                              FlutterFlowTheme.of(context)
                                                  .headlineSmallFamily,
                                          color: widget.timerTimeIntegerMs >=
                                                  300000
                                              ? const Color(0xFFA50707)
                                              : FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          fontSize: 22.0,
                                          letterSpacing: 0.0,
                                          useGoogleFonts:
                                              !FlutterFlowTheme.of(context)
                                                  .headlineSmallIsCustom,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if ((widget.name == null || widget.name == '') ||
                    (widget.pin == null || widget.pin == '') ||
                    (widget.name == ' '))
                  Align(
                    alignment: const AlignmentDirectional(0.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onLongPress: () async {
                        // falta logica en drag end
                        _model.setToCancel = await actions.sendjsontourl(
                          '{\"ticket_number\": ${widget.ticketNumber}}',
                          currentJwtToken,
                          FFAppConstants.setTicketToCancel,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _model.setToCancel!,
                              style: TextStyle(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            duration: const Duration(milliseconds: 4000),
                            backgroundColor:
                                FlutterFlowTheme.of(context).secondary,
                          ),
                        );

                        safeSetState(() {});
                      },
                      child: FlutterFlowIconButton(
                        borderRadius: 0.0,
                        buttonSize: 35.0,
                        icon: FaIcon(
                          FontAwesomeIcons.trashAlt,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 25.0,
                        ),
                        onPressed: () {
                          print('IconButton pressed ...');
                        },
                      ),
                    ),
                  ),
                SizedBox(
                  height: 100.0,
                  child: StyledVerticalDivider(
                    thickness: 4.0,
                    color: FlutterFlowTheme.of(context).alternate,
                    lineStyle: DividerLineStyle.dashdotted,
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 2.0,
              color: FlutterFlowTheme.of(context).alternate,
            ),
          ],
        ),
      ),
    ).animateOnActionTrigger(
      animationsMap['containerOnActionTriggerAnimation']!,
    );
  }
}
