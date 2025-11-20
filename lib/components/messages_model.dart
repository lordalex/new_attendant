import '/auth/firebase_auth/auth_util.dart';
import '/components/empty_message_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'messages_widget.dart' show MessagesWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MessagesModel extends FlutterFlowModel<MessagesWidget> {
  ///  Local state fields for this component.

  String responseColumn = '[]';

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - sendjsontourl] action in messages widget.
  String? responseListJson;
  // Model for emptyMessage component.
  late EmptyMessageModel emptyMessageModel;

  @override
  void initState(BuildContext context) {
    emptyMessageModel = createModel(context, () => EmptyMessageModel());
  }

  @override
  void dispose() {
    emptyMessageModel.dispose();
  }
}
