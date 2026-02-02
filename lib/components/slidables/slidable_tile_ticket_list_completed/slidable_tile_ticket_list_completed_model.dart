import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'slidable_tile_ticket_list_completed_widget.dart'
    show SlidableTileTicketListCompletedWidget;
import 'package:flutter/material.dart';

class SlidableTileTicketListCompletedModel
    extends FlutterFlowModel<SlidableTileTicketListCompletedWidget> {
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

  // Stores action output result for [Custom Action - base64toBytesAction] action in slidableTileTicketListCompleted widget.
  FFUploadedFile? clientPhoto;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
