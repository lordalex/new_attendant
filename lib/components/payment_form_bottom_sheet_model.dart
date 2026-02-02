import 'package:knexattendant/auth/firebase_auth/auth_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_theme.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:knexattendant/custom_code/actions/index.dart' as actions;
import 'package:knexattendant/flutter_flow/custom_functions.dart' as functions;
import 'package:knexattendant/index.dart';
import 'payment_form_bottom_sheet_widget.dart'
    show PaymentFormBottomSheetWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
