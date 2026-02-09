import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'slidable_tile_ticket_list_completed_model.dart';
export 'slidable_tile_ticket_list_completed_model.dart';
import '../../../models/ticket_model.dart';
import '../../../services/vehicle_service.dart';

class SlidableTileTicketListCompletedWidget extends StatefulWidget {
  const SlidableTileTicketListCompletedWidget({
    super.key,
    this.plate,
    this.profileImg,
    this.departureHour,
    required this.callback,
    Color? timeTextColor,
    required this.ticketNumber,
    this.tipAmount,
    this.ticketJson,
    this.apiUrl,
    this.idToken,
  }) : timeTextColor = timeTextColor ?? const Color(0xFF57636C);

  final String? plate;
  final String? profileImg;
  final String? departureHour;
  final Future Function()? callback;
  final Color timeTextColor;
  final String? ticketNumber;
  final String? tipAmount;
  final String? ticketJson;
  final String? apiUrl;
  final String? idToken;

  @override
  State<SlidableTileTicketListCompletedWidget> createState() =>
      _SlidableTileTicketListCompletedWidgetState();
}

class _SlidableTileTicketListCompletedWidgetState
    extends State<SlidableTileTicketListCompletedWidget>
    with TickerProviderStateMixin {
  late SlidableTileTicketListCompletedModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SlidableTileTicketListCompletedModel());

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
              _model.vehicleDisplayText = "Vehicle info unavailable";
            }
          } else {
            _model.vehicleDisplayText = "Vehicle info unavailable";
          }

          _model.isLoadingVehicle = false;
          safeSetState(() {});
        } catch (e) {
          print("[SlidableTile] Error: $e");
          _model.isLoadingVehicle = false;
          _model.vehicleDisplayText = "Vehicle info unavailable";
        }
      } else {
        // Legacy mode - use existing logic
        _model.isLoadingVehicle = false;
        _model.vehicleDisplayText = "Vehicle info unavailable";
      }
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
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 5.0, 0.0, 0.0),
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.071,
                            decoration: BoxDecoration(
                              color: const Color(0x1E131919),
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                            child: Align(
                              alignment: const AlignmentDirectional(0.0, 0.0),
                              child: Text(
                                valueOrDefault<String>(
                                  widget.plate,
                                  'error',
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 24.0,
                                      letterSpacing: 2.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        // Display time difference
                        if (_model.timeDifferenceText != null)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 4.0, 0.0, 0.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(4.0),
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 4.0, 0.0, 0.0),
                            child: Row(
                              children: [
                                Icon(Icons.directions_car,
                                    size: 14.0, color: Colors.grey[600]),
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
                ),
                SizedBox(
                  width: 130.0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 5.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidClock,
                              color: widget.timeTextColor,
                              size: 17.0,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    6.0, 0.0, 2.0, 0.0),
                                child: Text(
                                  valueOrDefault<String>(
                                    widget.departureHour,
                                    '00:00',
                                  ),
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w800,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: widget.timeTextColor,
                                        fontSize: 22.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w800,
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
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 3.0, 5.0, 3.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.coins,
                              color: widget.timeTextColor,
                              size: 17.0,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    6.0, 0.0, 2.0, 0.0),
                                child: Text(
                                  '\$${valueOrDefault<String>(
                                    widget.tipAmount,
                                    '0',
                                  )}',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w800,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: widget.timeTextColor,
                                        fontSize: 22.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w800,
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
