import 'package:knexattendant/auth/firebase_auth/auth_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_animations.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_icon_button.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_theme.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_timer.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:knexattendant/custom_code/actions/index.dart' as actions;
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
  })  : this.timeTextColor = timeTextColor ?? const Color(0xFF57636C),
        this.timerTimeIntegerMs = timerTimeIntegerMs ?? 0,
        this.vehicleInfo = vehicleInfo ?? ' ';

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
      _model.timerController.timer.setPresetTime(
        mSec: widget!.timerTimeIntegerMs,
        add: false,
      );
      _model.timerController.onResetTimer();

      _model.timerController.onStartTimer();
      _model.posx = 0.0;
      _model.updatePage(() {});
      if (widget!.profileImg != null && widget!.profileImg != '') {
        _model.clientPhoto = await actions.base64toBytesAction(
          widget!.profileImg!,
          'clientPhoto',
        );
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget!.date!,
            style: TextStyle(
              color: FlutterFlowTheme.of(context).primaryText,
            ),
          ),
          duration: Duration(milliseconds: 4000),
          backgroundColor: FlutterFlowTheme.of(context).secondary,
        ),
      );
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
            begin: Offset(0.0, 0.0),
            end: Offset(-100.0, 0.0),
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
            Duration(
              milliseconds: 150,
            ),
          );
          await widget.callback?.call();
          FFAppState().isTicketOn = true;
          FFAppState().ticketNumber = widget!.ticketNumber!;
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
                  padding:
                      EdgeInsetsDirectional.fromSTEB(15.0, 10.0, 15.0, 15.0),
                  child: Container(
                    width: 73.6,
                    height: 77.6,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: Image.asset(
                          'assets/images/profile_image_person.png',
                        ).image,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        _model.clientPhoto?.bytes ?? Uint8List.fromList([]),
                        width: 194.4,
                        height: 207.9,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'assets/images/error_image.png',
                          width: 194.4,
                          height: 207.9,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 7.0, 5.0, 7.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(-1.0, 0.0),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.464,
                            decoration: BoxDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  valueOrDefault<String>(
                                    widget!.date,
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
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 18.0, 0.0, 0.0),
                                    child: Text(
                                      '${widget!.name}',
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
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional(1.0, 0.0),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                      child: Container(
                        width: 120.0,
                        decoration: BoxDecoration(),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidClock,
                              color: valueOrDefault<Color>(
                                widget!.timerTimeIntegerMs >= 300000
                                    ? Color(0xFFA50707)
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
                                  padding: EdgeInsetsDirectional.fromSTEB(
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
                                        Duration(milliseconds: 1000),
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
                                          color: widget!.timerTimeIntegerMs >=
                                                  300000
                                              ? Color(0xFFA50707)
                                              : FlutterFlowTheme.of(context)
                                                  .primaryText,
                                          fontSize: 25.0,
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
                if ((widget!.name == null || widget!.name == '') ||
                    (widget!.pin == null || widget!.pin == '') ||
                    (widget!.name == ' '))
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onLongPress: () async {
                        // falta logica en drag end
                        _model.setToCancel = await actions.sendjsontourl(
                          '{\"ticket_number\": ${widget!.ticketNumber}}',
                          currentJwtToken!,
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
                            duration: Duration(milliseconds: 4000),
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
