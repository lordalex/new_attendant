import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'bottom_sheet_edit_data_space_widget.dart'
    show BottomSheetEditDataSpaceWidget;
import 'package:flutter/material.dart';

class BottomSheetEditDataSpaceModel
    extends FlutterFlowModel<BottomSheetEditDataSpaceWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Stores action output result for [Custom Action - sendjsontourl] action in Button widget.
  String? setTicketToParked;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
