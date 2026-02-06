import '/auth/firebase_auth/auth_util.dart';
import '/components/empty_component_list_view/empty_component_list_view_widget.dart';
import '/components/slidables/slidable_tile_ticket_list_arrival/slidable_tile_ticket_list_arrival_widget.dart';
import '/components/slidables/slidable_tile_ticket_list_completed/slidable_tile_ticket_list_completed_widget.dart';
import '/components/slidables/slidable_tile_ticket_list_departure/slidable_tile_ticket_list_departure_widget.dart';
import '/components/slidables/slidable_tile_ticket_list_parked/slidable_tile_ticket_list_parked_widget.dart';
import '/components/slidables/slidable_tile_ticket_list_processing/slidable_tile_ticket_list_processing_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'ticket_list_model.dart';
export 'ticket_list_model.dart';

class TicketListWidget extends StatefulWidget {
  const TicketListWidget({
    super.key,
    String? titleStatus,
    required this.status,
  }) : this.titleStatus = titleStatus ?? 'Text';

  final String titleStatus;
  final String? status;

  static String routeName = 'TicketList';
  static String routePath = '/ticketList';

  @override
  State<TicketListWidget> createState() => _TicketListWidgetState();
}

class _TicketListWidgetState extends State<TicketListWidget>
    with TickerProviderStateMixin {
  late TicketListModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TicketListModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (widget!.titleStatus == 'Arrival') {
        safeSetState(() {
          _model.tabBarController!.animateTo(
            0,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        });
      } else if (widget!.titleStatus == 'Processing-Arrival') {
        safeSetState(() {
          _model.tabBarController!.animateTo(
            1,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        });
      } else if (widget!.titleStatus == 'Parked') {
        safeSetState(() {
          _model.tabBarController!.animateTo(
            2,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        });
      } else if (widget!.titleStatus == 'Departure') {
        safeSetState(() {
          _model.tabBarController!.animateTo(
            3,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        });
      } else if (widget!.titleStatus == 'Processing-Departure') {
        safeSetState(() {
          _model.tabBarController!.animateTo(
            4,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        });
      } else if (widget!.titleStatus == 'Completed') {
        safeSetState(() {
          _model.tabBarController!.animateTo(
            5,
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        });
      }

      _model.instantTimer2?.cancel();
      _model.status = widget!.status!;
      safeSetState(() {});
      _model.tmpBuffer = ' ';
      safeSetState(() {});
      
      // Start intelligent polling
      _startIntelligentPolling();
    });
    
    // Add lifecycle observer for visibility changes
    WidgetsBinding.instance.addObserver(_lifecycleObserver);
    _model.tabBarController = TabController(
      vsync: this,
      length: 6,
      initialIndex: min(
          valueOrDefault<int>(
            () {
              if (widget!.status == 'Arrival') {
                return 0;
              } else if (widget!.status == 'Processing-Arrival') {
                return 1;
              } else {
                return 2;
              }
            }(),
            0,
          ),
          5),
    )..addListener(() => safeSetState(() {}));
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: Color(0xFF131919),
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () async {
              context.pushNamed(HomePageWidget.routeName);
            },
          ),
          title: Text(
            () {
              if (_model.tabBarCurrentIndex == 1) {
                return 'Processing-Arrival';
              } else if (_model.tabBarCurrentIndex == 2) {
                return 'Parked';
              } else if (_model.tabBarCurrentIndex == 3) {
                return 'Departure';
              } else if (_model.tabBarCurrentIndex == 4) {
                return 'Processing-Departure';
              } else if (_model.tabBarCurrentIndex == 5) {
                return 'Completed';
              } else {
                return 'Arrival';
              }
            }(),
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  font: GoogleFonts.roboto(
                    fontWeight:
                        FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                  ),
                  color: Colors.white,
                  fontSize: 23.0,
                  letterSpacing: 0.0,
                  fontWeight:
                      FlutterFlowTheme.of(context).headlineMedium.fontWeight,
                  fontStyle:
                      FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 2.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment(0.0, 0),
                        child: TabBar(
                          labelColor: FlutterFlowTheme.of(context).primaryText,
                          unselectedLabelColor:
                              FlutterFlowTheme.of(context).secondaryText,
                          labelStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleMediumFamily,
                                fontSize: 8.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .titleMediumIsCustom,
                              ),
                          unselectedLabelStyle: FlutterFlowTheme.of(context)
                              .titleMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .titleMediumFamily,
                                fontSize: 10.0,
                                letterSpacing: 0.0,
                                useGoogleFonts: !FlutterFlowTheme.of(context)
                                    .titleMediumIsCustom,
                              ),
                          indicatorColor: FlutterFlowTheme.of(context).primary,
                          tabs: [
                            Tab(
                              text: 'Arrival',
                              icon: Icon(
                                Icons.arrow_downward_outlined,
                              ),
                            ),
                            Tab(
                              text: 'Processing',
                              icon: Icon(
                                Icons.downloading_sharp,
                              ),
                            ),
                            Tab(
                              text: 'Parked',
                              icon: Icon(
                                Icons.local_parking_outlined,
                              ),
                            ),
                            Tab(
                              text: 'Departure',
                              icon: Icon(
                                Icons.arrow_outward_outlined,
                              ),
                            ),
                            Tab(
                              text: 'Processing',
                              icon: Icon(
                                Icons.downloading_rounded,
                              ),
                            ),
                            Tab(
                              text: 'Completed',
                              icon: Icon(
                                Icons.check,
                              ),
                            ),
                          ],
                          controller: _model.tabBarController,
                          onTap: (i) async {
                            [
                              () async {
                                if (Navigator.of(context).canPop()) {
                                  context.pop();
                                }
                                context.pushNamed(
                                  TicketListWidget.routeName,
                                  queryParameters: {
                                    'status': serializeParam(
                                      'Arrival',
                                      ParamType.String,
                                    ),
                                    'titleStatus': serializeParam(
                                      'Arrival',
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                              },
                              () async {
                                context.pushNamed(
                                  TicketListWidget.routeName,
                                  queryParameters: {
                                    'status': serializeParam(
                                      'Processing-Arrival',
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                              },
                              () async {
                                context.pushNamed(
                                  TicketListWidget.routeName,
                                  queryParameters: {
                                    'status': serializeParam(
                                      'Parked',
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                              },
                              () async {
                                context.pushNamed(
                                  TicketListWidget.routeName,
                                  queryParameters: {
                                    'titleStatus': serializeParam(
                                      'Departure',
                                      ParamType.String,
                                    ),
                                    'status': serializeParam(
                                      'Departure',
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                              },
                              () async {
                                context.pushNamed(
                                  TicketListWidget.routeName,
                                  queryParameters: {
                                    'status': serializeParam(
                                      'Processing-Departure',
                                      ParamType.String,
                                    ),
                                    'titleStatus': serializeParam(
                                      'Processing-Departure',
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                              },
                              () async {
                                if (Navigator.of(context).canPop()) {
                                  context.pop();
                                }
                                context.pushNamed(
                                  TicketListWidget.routeName,
                                  queryParameters: {
                                    'status': serializeParam(
                                      'Completed',
                                      ParamType.String,
                                    ),
                                    'titleStatus': serializeParam(
                                      'Completed',
                                      ParamType.String,
                                    ),
                                  }.withoutNulls,
                                  extra: <String, dynamic>{
                                    kTransitionInfoKey: TransitionInfo(
                                      hasTransition: true,
                                      transitionType: PageTransitionType.fade,
                                      duration: Duration(milliseconds: 0),
                                    ),
                                  },
                                );
                              }
                            ][i]();
                          },
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _model.tabBarController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Align(
                              alignment: AlignmentDirectional(0.0, -1.0),
                              child: SingleChildScrollView(
                                primary: false,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.7,
                                      decoration: BoxDecoration(),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Stack(
                                              children: [
                                                Builder(
                                                  builder: (context) {
                                                    final ticketL =
                                                        _model.tickets.toList();
                                                    if (ticketL.isEmpty) {
                                                      return Center(
                                                        child:
                                                            EmptyComponentListViewWidget(),
                                                      );
                                                    }

                                                    return ListView.builder(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                        0,
                                                        0,
                                                        0,
                                                        100.0,
                                                      ),
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount: ticketL.length,
                                                      itemBuilder: (context,
                                                          ticketLIndex) {
                                                        final ticketLItem =
                                                            ticketL[
                                                                ticketLIndex];
                                                        return Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          children: [
                                                            Expanded(
                                                              child:
                                                                  SlidableTileTicketListArrivalWidget(
                                                                key: Key(
                                                                    'Keymtk_${ticketLIndex}_of_${ticketL.length}'),
                                                                // NEW: Pass ticket JSON directly
                                                                ticketJson:
                                                                    ticketLItem,
                                                                apiUrl:
                                                                    FFAppConstants
                                                                        .baseUrl,
                                                                idToken:
                                                                    currentJwtToken,
                                                                // Legacy parameters (optional, for backward compatibility)
                                                                name: functions
                                                                    .tostr(
                                                                        '${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketLItem, 'user_client'), 'firstname')} ${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketLItem, 'user_client'), 'lastname')}'),
                                                                plate: functions.tostr(functions.getkeyfromjsonstring(
                                                                    functions.getkeyfromjsonstring(
                                                                        ticketLItem,
                                                                        'vehicleInfo'),
                                                                    'plate')),
                                                                profileImg:
                                                                    valueOrDefault<
                                                                        String>(
                                                                  functions.getkeyfromjsonstring(
                                                                      valueOrDefault<String>(
                                                                        functions.getkeyfromjsonstring(
                                                                            ticketLItem,
                                                                            'user_client'),
                                                                        'error',
                                                                      ),
                                                                      'photo'),
                                                                  'error',
                                                                ),
                                                                departureHour: functions.parseStringTimeToMinutesString(functions.replaceSubstringCaseInsensitive(
                                                                    functions.getkeyfromjsonstring(
                                                                        functions.extractTime(functions.getkeyfromjsonstring(
                                                                            ticketLItem,
                                                                            'created_at')),
                                                                        'time_difference'),
                                                                    '\"',
                                                                    '')),
                                                                timerTimeIntegerMs: functions.stringDateToMillisecondsInt(functions.replaceSubstringCaseInsensitive(
                                                                    functions.getkeyfromjsonstring(
                                                                        functions.extractTime(functions.getkeyfromjsonstring(
                                                                            ticketLItem,
                                                                            'created_at')),
                                                                        'time_difference'),
                                                                    '\"',
                                                                    '')),
                                                                vehicleInfo:
                                                                    functions.tostr(
                                                                        '${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketLItem, 'vehicleInfo'), 'model')} ${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketLItem, 'vehicleInfo'), 'color')}'),
                                                                date: functions
                                                                    .parseStringTimeToMinutesString(
                                                                        valueOrDefault<
                                                                            String>(
                                                                  functions.getkeyfromjsonstring(
                                                                      ticketLItem,
                                                                      'created_at'),
                                                                  'error',
                                                                )),
                                                                callback:
                                                                    () async {
                                                                  _model.removeAtIndexFromTickets(
                                                                      ticketLIndex);
                                                                  safeSetState(
                                                                      () {});
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                      content:
                                                                          Text(
                                                                        '{\"ticket_number\": ${functions.getkeyfromjsonstring(ticketLItem, 'ticket_number')}}',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).primaryText,
                                                                        ),
                                                                      ),
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              4000),
                                                                      backgroundColor:
                                                                          FlutterFlowTheme.of(context)
                                                                              .secondary,
                                                                    ),
                                                                  );
                                                                  // Use setStatus action with ticket ID
                                                                  _model.setToProcessing =
                                                                      await actions
                                                                          .setStatus(
                                                                    FFAppConstants
                                                                        .setTicketStatus,
                                                                    currentJwtToken!,
                                                                    'Processing-Arrival',
                                                                    functions.getkeyfromjsonstring(
                                                                        ticketLItem,
                                                                        'id'),
                                                                  );

                                                                  safeSetState(
                                                                      () {});
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                                if (((_model.tickets
                                                            .isNotEmpty) ==
                                                        false) &&
                                                    !_model.isLoadedQueryList)
                                                  Container(
                                                    height: MediaQuery.sizeOf(
                                                                context)
                                                            .height *
                                                        0.491,
                                                    decoration: BoxDecoration(
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              0.0, -1.0),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    60.0,
                                                                    0.0,
                                                                    0.0),
                                                        child: Lottie.asset(
                                                          'assets/jsons/loading2.json',
                                                          width: 180.58,
                                                          height: 185.1,
                                                          fit: BoxFit.contain,
                                                          frameRate:
                                                              FrameRate(60.0),
                                                          animate: true,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, -1.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.7,
                                    decoration: BoxDecoration(),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Stack(
                                            children: [
                                              Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, -1.0),
                                                child: Builder(
                                                  builder: (context) {
                                                    final ticketL =
                                                        _model.tickets.toList();
                                                    if (ticketL.isEmpty) {
                                                      return Center(
                                                        child:
                                                            EmptyComponentListViewWidget(),
                                                      );
                                                    }

                                                    return ListView.builder(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                        0,
                                                        0,
                                                        0,
                                                        100.0,
                                                      ),
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      itemCount: ticketL.length,
                                                      itemBuilder: (context,
                                                          ticketLIndex) {
                                                        final ticketLItem =
                                                            ticketL[
                                                                ticketLIndex];
                                                        return Stack(
                                                          children: [
                                                            SlidableTileTicketListProcessingWidget(
                                                              key: Key(
                                                                  'Keye6x_${ticketLIndex}_of_${ticketL.length}'),
                                                              ticketJson:
                                                                  ticketLItem,
                                                              apiUrl:
                                                                  FFAppConstants
                                                                      .baseUrl,
                                                              idToken:
                                                                  currentJwtToken,
                                                              name: functions.tostr(
                                                                  '${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketLItem, 'user_client'), 'firstname')} ${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketLItem, 'user_client'), 'lastname')}'),
                                                              plate: functions.tostr(
                                                                  functions.getkeyfromjsonstring(
                                                                      functions.getkeyfromjsonstring(
                                                                          ticketLItem,
                                                                          'vehicleInfo'),
                                                                      'plate')),
                                                              profileImg:
                                                                  valueOrDefault<
                                                                      String>(
                                                                functions
                                                                    .getkeyfromjsonstring(
                                                                        valueOrDefault<
                                                                            String>(
                                                                          functions.getkeyfromjsonstring(
                                                                              ticketLItem,
                                                                              'user_client'),
                                                                          'error',
                                                                        ),
                                                                        'photo'),
                                                                'error',
                                                              ),
                                                              departureHour: functions.parseStringTimeToMinutesString(functions.replaceSubstringCaseInsensitive(
                                                                  functions.getkeyfromjsonstring(
                                                                      functions.extractTime(functions.getkeyfromjsonstring(
                                                                          ticketLItem,
                                                                          'created_at')),
                                                                      'time_difference'),
                                                                  '\"',
                                                                  '')),
                                                              ticketNumber: functions
                                                                  .getkeyfromjsonstring(
                                                                      ticketLItem,
                                                                      'ticket_number'),
                                                              timerTimeIntegerMs: functions.stringDateToMillisecondsInt(functions.replaceSubstringCaseInsensitive(
                                                                  functions.getkeyfromjsonstring(
                                                                      functions.extractTime(functions.getkeyfromjsonstring(
                                                                          ticketLItem,
                                                                          'created_at')),
                                                                      'time_difference'),
                                                                  '\"',
                                                                  '')),
                                                              vehicleInfo:
                                                                  functions.tostr(
                                                                      '${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketLItem, 'vehicleInfo'), 'model')} ${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketLItem, 'vehicleInfo'), 'color')}'),
                                                              pin: functions
                                                                  .getkeyfromjsonstring(
                                                                      ticketLItem,
                                                                      'PIN'),
                                                              date: functions
                                                                  .getkeyfromjsonstring(
                                                                      ticketLItem,
                                                                      'created_at'),
                                                              callback:
                                                                  () async {
                                                                await Future
                                                                    .delayed(
                                                                  Duration(
                                                                    milliseconds:
                                                                        150,
                                                                  ),
                                                                );
                                                                _model.posx =
                                                                    0.0;

                                                                await _navigateToTicketDetail(
                                                                  functions.getkeyfromjsonstring(
                                                                      ticketLItem,
                                                                      'ticket_number'),
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                              if (((_model.tickets
                                                          .isNotEmpty) ==
                                                      false) &&
                                                  !_model.isLoadedQueryList)
                                                Container(
                                                  height:
                                                      MediaQuery.sizeOf(context)
                                                              .height *
                                                          0.491,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                  ),
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, -1.0),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  60.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Lottie.asset(
                                                        'assets/jsons/loading2.json',
                                                        width: 180.58,
                                                        height: 185.1,
                                                        fit: BoxFit.contain,
                                                        frameRate:
                                                            FrameRate(60.0),
                                                        animate: true,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              primary: false,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Stack(
                                    children: [
                                      Align(
                                        alignment:
                                            AlignmentDirectional(0.0, -1.0),
                                        child: Builder(
                                          builder: (context) {
                                            final ticketL =
                                                _model.tickets.toList();
                                            if (ticketL.isEmpty) {
                                              return EmptyComponentListViewWidget();
                                            }

                                            return ListView.builder(
                                              padding: EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                0,
                                                100.0,
                                              ),
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              itemCount: ticketL.length,
                                              itemBuilder:
                                                  (context, ticketLIndex) {
                                                final ticketLItem =
                                                    ticketL[ticketLIndex];
                                                return SlidableTileTicketListParkedWidget(
                                                  key: Key(
                                                      'Key8cc_${ticketLIndex}_of_${ticketL.length}'),
                                                  ticketJson: ticketLItem,
                                                  apiUrl:
                                                      FFAppConstants.baseUrl,
                                                  idToken: currentJwtToken,
                                                  name:
                                                      '${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketLItem, 'user_client'), 'firstname')} ${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketLItem, 'user_client'), 'lastname')}',
                                                  plate: functions.tostr(functions
                                                      .getkeyfromjsonstring(
                                                          functions
                                                              .getkeyfromjsonstring(
                                                                  ticketLItem,
                                                                  'vehicleInfo'),
                                                          'plate')),
                                                  profileImg:
                                                      valueOrDefault<String>(
                                                    functions
                                                        .getkeyfromjsonstring(
                                                            valueOrDefault<
                                                                String>(
                                                              functions.getkeyfromjsonstring(
                                                                  ticketLItem,
                                                                  'user_client'),
                                                              'error',
                                                            ),
                                                            'photo'),
                                                    'error',
                                                  ),
                                                  departureHour: functions.parseStringTimeToMinutesString(
                                                      functions.replaceSubstringCaseInsensitive(
                                                          functions.getkeyfromjsonstring(
                                                              functions.extractTime(
                                                                  functions.getkeyfromjsonstring(
                                                                      ticketLItem,
                                                                      'created_at')),
                                                              'time_difference'),
                                                          '\"',
                                                          '')),
                                                  timerTimeIntegerMs: functions.stringDateToMillisecondsInt(
                                                      functions.replaceSubstringCaseInsensitive(
                                                          functions.getkeyfromjsonstring(
                                                              functions.extractTime(
                                                                  functions.getkeyfromjsonstring(
                                                                      ticketLItem,
                                                                      'created_at')),
                                                              'time_difference'),
                                                          '\"',
                                                          '')),
                                                  lockerSpace: functions
                                                      .getkeyfromjsonstring(
                                                          ticketLItem,
                                                          'lockerSpace'),
                                                  parkingSpace: functions
                                                      .getkeyfromjsonstring(
                                                          ticketLItem,
                                                          'parkingSpace'),
                                                  ticketNumber: functions
                                                      .getkeyfromjsonstring(
                                                          ticketLItem,
                                                          'ticket_number'),
                                                  callback: () async {
                                                    await _navigateToTicketDetail(
                                                      functions.getkeyfromjsonstring(
                                                          ticketLItem,
                                                          'ticket_number'),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      if (!_model.isLoadedQueryList)
                                        Container(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.491,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 60.0, 0.0, 0.0),
                                              child: Lottie.asset(
                                                'assets/jsons/loading2.json',
                                                width: 180.58,
                                                height: 185.1,
                                                fit: BoxFit.contain,
                                                frameRate: FrameRate(60.0),
                                                animate: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Stack(
                                  children: [
                                    Align(
                                      alignment:
                                          AlignmentDirectional(0.0, -1.0),
                                      child: Builder(
                                        builder: (context) {
                                          final ticketsDeparture =
                                              _model.tickets.toList();
                                          if (ticketsDeparture.isEmpty) {
                                            return EmptyComponentListViewWidget();
                                          }

                                          return ListView.builder(
                                            padding: EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              0,
                                              100.0,
                                            ),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: ticketsDeparture.length,
                                            itemBuilder: (context,
                                                ticketsDepartureIndex) {
                                              final ticketsDepartureItem =
                                                  ticketsDeparture[
                                                      ticketsDepartureIndex];
                                              return Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child:
                                                        SlidableTileTicketListDepartureWidget(
                                                      key: Key(
                                                          'Key1f5_${ticketsDepartureIndex}_of_${ticketsDeparture.length}'),
                                                      ticketJson:
                                                          ticketsDepartureItem,
                                                      apiUrl: FFAppConstants
                                                          .baseUrl,
                                                      idToken: currentJwtToken,
                                                      name:
                                                          '${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketsDepartureItem, 'user_client'), 'firstname')} ${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketsDepartureItem, 'user_client'), 'lastname')}',
                                                      plate: functions.tostr(functions
                                                          .getkeyfromjsonstring(
                                                              functions.getkeyfromjsonstring(
                                                                  ticketsDepartureItem,
                                                                  'vehicleInfo'),
                                                              'plate')),
                                                      profileImg:
                                                          valueOrDefault<
                                                              String>(
                                                        functions
                                                            .getkeyfromjsonstring(
                                                                valueOrDefault<
                                                                    String>(
                                                                  functions.getkeyfromjsonstring(
                                                                      ticketsDepartureItem,
                                                                      'user_client'),
                                                                  'error',
                                                                ),
                                                                'photo'),
                                                        'error',
                                                      ),
                                                      departureHour: functions.parseStringTimeToMinutesString(functions.replaceSubstringCaseInsensitive(
                                                          functions.getkeyfromjsonstring(
                                                              functions.extractTime(
                                                                  functions.getkeyfromjsonstring(
                                                                      ticketsDepartureItem,
                                                                      'created_at')),
                                                              'time_difference'),
                                                          '\"',
                                                          '')),
                                                      timerTimeIntegerMs: functions.stringDateToMillisecondsInt(functions.replaceSubstringCaseInsensitive(
                                                          functions.getkeyfromjsonstring(
                                                              functions.extractTime(
                                                                  functions.getkeyfromjsonstring(
                                                                      ticketsDepartureItem,
                                                                      'created_at')),
                                                              'time_difference'),
                                                          '\"',
                                                          '')),
                                                      lockerSpace: functions
                                                          .getkeyfromjsonstring(
                                                              ticketsDepartureItem,
                                                              'lockerSpace'),
                                                      parkingSpace: functions
                                                          .getkeyfromjsonstring(
                                                              ticketsDepartureItem,
                                                              'parkingSpace'),
                                                      ticketNumber: functions
                                                          .getkeyfromjsonstring(
                                                              ticketsDepartureItem,
                                                              'ticket_number'),
                                                      callback: () async {
                                                        _model.removeAtIndexFromTickets(
                                                            ticketsDepartureIndex);
                                                        safeSetState(() {});
                                                        // Use setStatus action with ticket ID
                                                        _model.setToProcessingDeparture =
                                                            await actions
                                                                .setStatus(
                                                          FFAppConstants
                                                              .setTicketStatus,
                                                          currentJwtToken!,
                                                          'Processing-Departure',
                                                          functions.getkeyfromjsonstring(
                                                              ticketsDepartureItem,
                                                              'id'),
                                                        );

                                                        safeSetState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    if (((_model.tickets.isNotEmpty) ==
                                            false) &&
                                        !_model.isLoadedQueryList)
                                      Container(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.491,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                        ),
                                        alignment:
                                            AlignmentDirectional(0.0, 0.0),
                                        child: Align(
                                          alignment:
                                              AlignmentDirectional(0.0, -1.0),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 60.0, 0.0, 0.0),
                                            child: Lottie.asset(
                                              'assets/jsons/loading2.json',
                                              width: 180.58,
                                              height: 185.1,
                                              fit: BoxFit.contain,
                                              frameRate: FrameRate(60.0),
                                              animate: true,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Stack(
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          final ticketsProcessingDeparture =
                                              _model.tickets.toList();
                                          if (ticketsProcessingDeparture
                                              .isEmpty) {
                                            return EmptyComponentListViewWidget();
                                          }

                                          return ListView.builder(
                                            padding: EdgeInsets.fromLTRB(
                                              0,
                                              0,
                                              0,
                                              100.0,
                                            ),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount:
                                                ticketsProcessingDeparture
                                                    .length,
                                            itemBuilder: (context,
                                                ticketsProcessingDepartureIndex) {
                                              final ticketsProcessingDepartureItem =
                                                  ticketsProcessingDeparture[
                                                      ticketsProcessingDepartureIndex];
                                              return SlidableTileTicketListProcessingWidget(
                                                key: Key(
                                                    'Keywps_${ticketsProcessingDepartureIndex}_of_${ticketsProcessingDeparture.length}'),
                                                name:
                                                    '${'${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketsProcessingDepartureItem, 'user_client'), 'firstname')} ${functions.getkeyfromjsonstring(functions.getkeyfromjsonstring(ticketsProcessingDepartureItem, 'user_client'), 'lastname')}'} ${functions.tostr(functions.getkeyfromjsonstring(ticketsProcessingDepartureItem, 'parkingSpace'))}',
                                                plate: functions.tostr(functions
                                                    .getkeyfromjsonstring(
                                                        functions
                                                            .getkeyfromjsonstring(
                                                                ticketsProcessingDepartureItem,
                                                                'vehicleInfo'),
                                                        'plate')),
                                                profileImg:
                                                    valueOrDefault<String>(
                                                  functions
                                                      .getkeyfromjsonstring(
                                                          valueOrDefault<
                                                              String>(
                                                            functions.getkeyfromjsonstring(
                                                                ticketsProcessingDepartureItem,
                                                                'user_client'),
                                                            'error',
                                                          ),
                                                          'photo'),
                                                  'error',
                                                ),
                                                departureHour: functions.parseStringTimeToMinutesString(
                                                    functions.replaceSubstringCaseInsensitive(
                                                        functions.getkeyfromjsonstring(
                                                            functions.extractTime(
                                                                functions.getkeyfromjsonstring(
                                                                    ticketsProcessingDepartureItem,
                                                                    'created_at')),
                                                            'time_difference'),
                                                        '\"',
                                                        '')),
                                                ticketNumber: functions
                                                    .getkeyfromjsonstring(
                                                        functions
                                                            .getkeyfromjsonstring(
                                                                ticketsProcessingDepartureItem,
                                                                'vehicleInfo'),
                                                        'ticket_number'),
                                                pin: functions.getkeyfromjsonstring(
                                                    ticketsProcessingDepartureItem,
                                                    'pin'),
                                                date: functions
                                                    .getkeyfromjsonstring(
                                                        ticketsProcessingDepartureItem,
                                                        'created_at'),
                                                callback: () async {
                                                  await _navigateToTicketDetail(
                                                    functions.getkeyfromjsonstring(
                                                        ticketsProcessingDepartureItem,
                                                        'ticket_number'),
                                                  );
                                                  _model.posx = 0.0;
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      if (((_model.tickets.isNotEmpty) ==
                                              false) &&
                                          !_model.isLoadedQueryList)
                                        Container(
                                          height: MediaQuery.sizeOf(context)
                                                  .height *
                                              0.491,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                          ),
                                          alignment:
                                              AlignmentDirectional(0.0, 0.0),
                                          child: Align(
                                            alignment:
                                                AlignmentDirectional(0.0, -1.0),
                                            child: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 60.0, 0.0, 0.0),
                                              child: Lottie.asset(
                                                'assets/jsons/loading2.json',
                                                width: 180.58,
                                                height: 185.1,
                                                fit: BoxFit.contain,
                                                frameRate: FrameRate(60.0),
                                                animate: true,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                if (!(((_model.tickets.isNotEmpty) == false) &&
                                    !_model.isLoadedQueryList))
                                  Container(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.717,
                                    decoration: BoxDecoration(),
                                    child:
                                        // historial de carros parkeados en las ultimas 24h
                                        Builder(
                                      builder: (context) {
                                        final ticketsProcessingCompleted =
                                            _model.tickets.toList();
                                        if (ticketsProcessingCompleted
                                            .isEmpty) {
                                          return EmptyComponentListViewWidget();
                                        }

                                        return ListView.builder(
                                          padding: EdgeInsets.fromLTRB(
                                            0,
                                            0,
                                            0,
                                            50.0,
                                          ),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              ticketsProcessingCompleted.length,
                                          itemBuilder: (context,
                                              ticketsProcessingCompletedIndex) {
                                            final ticketsProcessingCompletedItem =
                                                ticketsProcessingCompleted[
                                                    ticketsProcessingCompletedIndex];
                                            return SlidableTileTicketListCompletedWidget(
                                              key: Key(
                                                  'Keylrg_${ticketsProcessingCompletedIndex}_of_${ticketsProcessingCompleted.length}'),
                                              ticketJson:
                                                  ticketsProcessingCompletedItem,
                                              apiUrl: FFAppConstants.baseUrl,
                                              idToken: currentJwtToken,
                                              plate: functions.tostr(functions
                                                  .getkeyfromjsonstring(
                                                      functions
                                                          .getkeyfromjsonstring(
                                                              ticketsProcessingCompletedItem,
                                                              'vehicleInfo'),
                                                      'plate')),
                                              profileImg:
                                                  valueOrDefault<String>(
                                                functions.getkeyfromjsonstring(
                                                    valueOrDefault<String>(
                                                      functions
                                                          .getkeyfromjsonstring(
                                                              ticketsProcessingCompletedItem,
                                                              'user_client'),
                                                      'error',
                                                    ),
                                                    'photo'),
                                                'error',
                                              ),
                                              departureHour: functions.parseStringTimeToMinutesString(
                                                  functions.replaceSubstringCaseInsensitive(
                                                      functions.getkeyfromjsonstring(
                                                          functions.extractTime(
                                                              functions.getkeyfromjsonstring(
                                                                  ticketsProcessingCompletedItem,
                                                                  'created_at')),
                                                          'time_difference'),
                                                      '\"',
                                                      '')),
                                              ticketNumber: functions
                                                  .getkeyfromjsonstring(
                                                      functions
                                                          .getkeyfromjsonstring(
                                                              ticketsProcessingCompletedItem,
                                                              'vehicleInfo'),
                                                      'ticket_number'),
                                              tipAmount: valueOrDefault<String>(
                                                functions.getkeyfromjsonstring(
                                                    functions.getkeyfromjsonstring(
                                                        ticketsProcessingCompletedItem,
                                                        'vehicleInfo'),
                                                    'tip'),
                                                '0',
                                              ),
                                              callback: () async {},
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                if (((_model.tickets.isNotEmpty) == false) &&
                                    !_model.isLoadedQueryList)
                                  Container(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.491,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                    ),
                                    alignment: AlignmentDirectional(0.0, 0.0),
                                    child: Align(
                                      alignment:
                                          AlignmentDirectional(0.0, -1.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 60.0, 0.0, 0.0),
                                        child: Lottie.asset(
                                          'assets/jsons/loading2.json',
                                          width: 180.58,
                                          height: 185.1,
                                          fit: BoxFit.contain,
                                          frameRate: FrameRate(60.0),
                                          animate: true,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
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
      ),
    );
  }

  // Lifecycle observer to detect when app goes to background/foreground
  late final _lifecycleObserver = _LifecycleEventObserver(
    onResume: () => _model.onResume(),
    onPause: () => _model.onPause(),
  );

  // Route observer to detect navigation to/from detail pages
  late final _routeObserver = RouteObserver<PageRoute>();

  // Start intelligent polling that respects HTTP operations and visibility
  void _startIntelligentPolling() {
    print('[TicketList] Starting intelligent polling');
    
    // Immediate first fetch
    _fetchTicketList();
    
    // Setup periodic timer with intelligent checks
    _model.instantTimer2 = InstantTimer.periodic(
      duration: Duration(milliseconds: 7600),
      callback: (timer) async {
        // Skip if we shouldn't fetch (HTTP busy, not visible, or paused)
        if (!_model.shouldFetch()) {
          print('[TicketList] Skipping fetch - canFetch: ${_model.canFetch}, shouldFetch: ${_model.shouldFetch()}');
          return;
        }
        
        await _fetchTicketList();
      },
      startImmediately: false, // We already did the first fetch
    );
  }

  // Navigate to ticket detail with polling pause
  Future<void> _navigateToTicketDetail(String ticketNumber) async {
    _model.onNavigateToDetail();
    
    // Clean the ticket number by removing surrounding quotes if present
    final cleanTicketNumber = ticketNumber.replaceAll('"', '').trim();
    
    await context.pushNamed(
      TicketWidget.routeName,
      queryParameters: {
        'ticketID': serializeParam(
          cleanTicketNumber,
          ParamType.String,
        ),
      }.withoutNulls,
    );
    
    // When we return, refresh and resume polling
    _model.onReturnFromDetail();
    await _fetchTicketList();
    
    // Restart the polling timer
    _startIntelligentPolling();
  }

  // Fetch ticket list with error handling
  Future<void> _fetchTicketList() async {
    try {
      _model.updateLastFetchTime();
      
      _model.ticketlistA = await actions.sendjsontourl(
        '{"status": "${widget.status}"}',
        currentJwtToken!,
        FFAppConstants.ticketListURL,
      );
      
      if (_model.ticketlistA == '401') {
        if (mounted) {
          context.pushNamed(LoginPageWidget.routeName);
        }
        _model.instantTimer2?.cancel();
        return;
      }
      
      // Only update UI if data changed
      if (_model.tmpBuffer != _model.ticketlistA) {
        _model.isLoadedQueryList = false;
        _model.tickets = [];
        _model.tickets = functions
            .jsontoArray(_model.ticketlistA!)
            .toList()
            .cast<String>();
        _model.isLoadedQueryList = true;
        
        if (mounted) {
          safeSetState(() {});
        }
      }
    } catch (e) {
      print('[TicketList] Error fetching tickets: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_lifecycleObserver);
    super.dispose();
  }
}

// Helper class to observe app lifecycle events
class _LifecycleEventObserver extends WidgetsBindingObserver {
  final VoidCallback onResume;
  final VoidCallback onPause;

  _LifecycleEventObserver({
    required this.onResume,
    required this.onPause,
  });

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
        onPause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }
}
