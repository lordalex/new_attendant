import 'package:knexattendant/flutter_flow/flutter_flow_animations.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_theme.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:knexattendant/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'slidable_tile_ticket_list_completed_model.dart';
export 'slidable_tile_ticket_list_completed_model.dart';

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
  }) : this.timeTextColor = timeTextColor ?? const Color(0xFF57636C);

  final String? plate;
  final String? profileImg;
  final String? departureHour;
  final Future Function()? callback;
  final Color timeTextColor;
  final String? ticketNumber;
  final String? tipAmount;

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
      _model.clientPhoto = await actions.base64toBytesAction(
        widget!.profileImg!,
        'clientPhoto',
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
                    width: 60.0,
                    height: 58.1,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: Image.memory(
                          _model.clientPhoto?.bytes ?? Uint8List.fromList([]),
                        ).image,
                      ),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.memory(
                        _model.clientPhoto?.bytes ?? Uint8List.fromList([]),
                        width: 209.91,
                        height: 215.5,
                        fit: BoxFit.cover,
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
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 5.0, 0.0, 0.0),
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.071,
                            decoration: BoxDecoration(
                              color: Color(0x1E131919),
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(
                                color:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                            ),
                            child: Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Text(
                                valueOrDefault<String>(
                                  widget!.plate,
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
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(1.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 5.0, 0.0),
                          child: Container(
                            width: 120.0,
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.solidClock,
                                  color: widget!.timeTextColor,
                                  size: 17.0,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        6.0, 0.0, 2.0, 0.0),
                                    child: Text(
                                      valueOrDefault<String>(
                                        widget!.departureHour,
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
                                            color: widget!.timeTextColor,
                                            fontSize: 21.5,
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
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(1.0, 0.0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 5.0, 0.0),
                          child: Container(
                            width: 120.0,
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.coins,
                                  color: widget!.timeTextColor,
                                  size: 17.0,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        6.0, 0.0, 2.0, 0.0),
                                    child: Text(
                                      '\$${valueOrDefault<String>(
                                        widget!.tipAmount,
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
                                            color: widget!.timeTextColor,
                                            fontSize: 21.5,
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
