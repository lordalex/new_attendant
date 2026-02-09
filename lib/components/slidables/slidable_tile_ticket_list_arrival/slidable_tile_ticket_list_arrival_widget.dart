import '/flutter_flow/flutter_flow_animations.dart';
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
import 'slidable_tile_ticket_list_arrival_model.dart';
export 'slidable_tile_ticket_list_arrival_model.dart';
import '../../../models/ticket_model.dart';
import '../../../services/vehicle_service.dart';

class SlidableTileTicketListArrivalWidget extends StatefulWidget {
  const SlidableTileTicketListArrivalWidget({
    super.key,
    this.name,
    this.plate,
    this.profileImg,
    this.departureHour,
    required this.callback,
    Color? timeTextColor,
    int? timerTimeIntegerMs,
    String? vehicleInfo,
    required this.date,
    // NEW: Accept ticket JSON directly
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

  /// required
  final int timerTimeIntegerMs;

  /// Combined Vehicle Info
  final String vehicleInfo;

  final String? date;

  // NEW: Ticket data for new system
  final String? ticketJson;
  final String? apiUrl;
  final String? idToken;

  @override
  State<SlidableTileTicketListArrivalWidget> createState() =>
      _SlidableTileTicketListArrivalWidgetState();
}

class _SlidableTileTicketListArrivalWidgetState
    extends State<SlidableTileTicketListArrivalWidget>
    with TickerProviderStateMixin {
  late SlidableTileTicketListArrivalModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SlidableTileTicketListArrivalModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.timerController.timer.setPresetTime(
        mSec: widget.timerTimeIntegerMs,
        add: false,
      );
      _model.timerController.onResetTimer();

      _model.timerController.onStartTimer();

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
            _model.clientPhoto1 = await actions.base64toBytesAction(
              _model.ticket!.clientPhotoUrl!,
              'clientPhoto',
            );
            _model.clientPhoto = _model.clientPhoto1;
          } else {
            print("[SlidableTile] Using default photo");
            _model.clientPhoto2 = await actions.base64toBytesAction(
              FFAppState().defaultpic,
              'clientPhoto',
            );
            _model.clientPhoto = _model.clientPhoto2;
          }

          // Fetch vehicle data if available
          if (widget.apiUrl != null &&
              widget.idToken != null &&
              _model.ticket!.vehicle.isNotEmpty) {
            print(
                "[SlidableTile] Fetching vehicle data for: ${_model.ticket!.vehicle}");
            final vehicleService = VehicleService(
              apiUrl: widget.apiUrl!,
              idToken: widget.idToken!,
            );

            final vehicleData = await vehicleService
                .fetchVehicleDetails(_model.ticket!.vehicle);
            if (vehicleData != null) {
              print("[SlidableTile] Vehicle data loaded successfully");
              _model.ticket = _model.ticket!.copyWith(vehicleData: vehicleData);
              _model.vehicleDisplayText = _model.ticket!.formattedVehicle;
            } else {
              print("[SlidableTile] Vehicle data not found");
              _model.vehicleDisplayText = widget.vehicleInfo != ' '
                  ? widget.vehicleInfo
                  : "Vehicle info unavailable";
            }
          } else {
            // Fallback to provided vehicleInfo
            _model.vehicleDisplayText = widget.vehicleInfo != ' '
                ? widget.vehicleInfo
                : "Vehicle info unavailable";
          }

          _model.isLoadingVehicle = false;
          safeSetState(() {});
        } catch (e) {
          print("[SlidableTile] Error loading ticket data: $e");
          // Fallback to old behavior
          _model.isLoadingVehicle = false;
          _model.vehicleDisplayText = widget.vehicleInfo != ' '
              ? widget.vehicleInfo
              : "Vehicle info unavailable";
          _model.timeDifferenceText = null;

          if (widget.profileImg != null && widget.profileImg != '') {
            _model.clientPhoto1 = await actions.base64toBytesAction(
              widget.profileImg!,
              'clientPhoto',
            );
            _model.clientPhoto = _model.clientPhoto1;
          } else {
            _model.clientPhoto2 = await actions.base64toBytesAction(
              FFAppState().defaultpic,
              'clientPhoto',
            );
            _model.clientPhoto = _model.clientPhoto2;
          }
          safeSetState(() {});
        }
      } else {
        // OLD BEHAVIOR: Use individual parameters
        print("[SlidableTile] Using legacy parameter mode");
        if (widget.profileImg != null && widget.profileImg != '') {
          _model.clientPhoto1 = await actions.base64toBytesAction(
            widget.profileImg!,
            'clientPhoto',
          );
          _model.clientPhoto = _model.clientPhoto1;
          safeSetState(() {});
        } else {
          _model.clientPhoto2 = await actions.base64toBytesAction(
            FFAppState().defaultpic,
            'clientPhoto',
          );
          _model.clientPhoto = _model.clientPhoto2;
          _model.updatePage(() {});
        }
        _model.isLoadingVehicle = false;
        _model.vehicleDisplayText = widget.vehicleInfo != ' '
            ? widget.vehicleInfo
            : "Vehicle info unavailable";
      }
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
    context.watch<FFAppState>();

    return GestureDetector(
      onHorizontalDragUpdate: (details) async {
        if (details.delta.dx < 0.36) {
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
                                  widget.date!,
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
                                // NEW: Display time difference
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
                                // NEW: Display vehicle info
                                if (_model.vehicleDisplayText != null)
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 4.0, 0.0, 0.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.directions_car,
                                          size: 14.0,
                                          color: Colors.grey[600],
                                        ),
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
                                // NEW: Display plate if available
                                if (widget.plate != null &&
                                    widget.plate!.isNotEmpty)
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0.0, 2.0, 0.0, 0.0),
                                    child: Text(
                                      "Plate: ${widget.plate}",
                                      style: TextStyle(
                                        fontSize: 11.0,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
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
                                      valueOrDefault<String>(
                                        widget.name,
                                        'FULL NAME',
                                      ),
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
                                                .primary,
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
                              color: widget.timerTimeIntegerMs >= 300000
                                  ? const Color(0xFFA50707)
                                  : FlutterFlowTheme.of(context).primaryText,
                              size: 17.0,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            6.0, 0.0, 0.0, 0.0),
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
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100.0,
                  child: StyledVerticalDivider(
                    thickness: 2.0,
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
