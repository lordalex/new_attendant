import '/flutter_flow/flutter_flow_util.dart';
import 'payment_form_bottom_sheet_widget.dart'
    show PaymentFormBottomSheetWidget;
import 'package:flutter/material.dart';

class PaymentFormBottomSheetModel
    extends FlutterFlowModel<PaymentFormBottomSheetWidget> {
  ///  Local state fields for this component.

  int integerSelector = 1;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Custom Action - sendjsontourl] action in Button widget.
  String? payment;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
