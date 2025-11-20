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
import 'ticket_list_widget.dart' show TicketListWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class TicketListModel extends FlutterFlowModel<TicketListWidget> {
  ///  Local state fields for this page.

  String status = 'Arrival';

  double posx = 0.0;

  List<String> tickets = [];
  void addToTickets(String item) => tickets.add(item);
  void removeFromTickets(String item) => tickets.remove(item);
  void removeAtIndexFromTickets(int index) => tickets.removeAt(index);
  void insertAtIndexInTickets(int index, String item) =>
      tickets.insert(index, item);
  void updateTicketsAtIndex(int index, Function(String) updateFn) =>
      tickets[index] = updateFn(tickets[index]);

  List<double> posxx = [];
  void addToPosxx(double item) => posxx.add(item);
  void removeFromPosxx(double item) => posxx.remove(item);
  void removeAtIndexFromPosxx(int index) => posxx.removeAt(index);
  void insertAtIndexInPosxx(int index, double item) =>
      posxx.insert(index, item);
  void updatePosxxAtIndex(int index, Function(double) updateFn) =>
      posxx[index] = updateFn(posxx[index]);

  bool isLoadedQueryList = false;

  String? statusQuery;

  bool boolHandlerLoops = false;

  String prvStatus = ' ';

  String tmpBuffer = ' ';

  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer2;
  // Stores action output result for [Custom Action - sendjsontourl] action in TicketList widget.
  String? ticketlistA;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Stores action output result for [Custom Action - sendjsontourl] action in slidableTileTicketListArrival widget.
  String? setToProcessing;
  // Stores action output result for [Custom Action - sendjsontourl] action in slidableTileTicketListDeparture widget.
  String? setToProcessingDeparture;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer2?.cancel();
    tabBarController?.dispose();
  }
}
