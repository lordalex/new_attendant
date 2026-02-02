import 'package:knexattendant/flutter_flow/flutter_flow_timer.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'slidable_tile_ticket_list_departure_widget.dart'
    show SlidableTileTicketListDepartureWidget;
import 'package:flutter/material.dart';

class SlidableTileTicketListDepartureModel
    extends FlutterFlowModel<SlidableTileTicketListDepartureWidget> {
  ///  Local state fields for this component.

  List<double> posxx = [];
  void addToPosxx(double item) => posxx.add(item);
  void removeFromPosxx(double item) => posxx.remove(item);
  void removeAtIndexFromPosxx(int index) => posxx.removeAt(index);
  void insertAtIndexInPosxx(int index, double item) =>
      posxx.insert(index, item);
  void updatePosxxAtIndex(int index, Function(double) updateFn) =>
      posxx[index] = updateFn(posxx[index]);

  double posx = 0.0;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - base64toBytesAction] action in slidableTileTicketListDeparture widget.
  FFUploadedFile? clientPhoto;
  // State field(s) for Timer widget.
  final timerInitialTimeMs = 0;
  int timerMilliseconds = 0;
  String timerValue = StopWatchTimer.getDisplayTime(
    0,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countUp));

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    timerController.dispose();
  }
}
