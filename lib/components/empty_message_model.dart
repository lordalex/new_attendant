import 'package:knexattendant/auth/firebase_auth/auth_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_theme.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_widgets.dart';
import 'package:knexattendant/custom_code/actions/index.dart' as actions;
import 'empty_message_widget.dart' show EmptyMessageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EmptyMessageModel extends FlutterFlowModel<EmptyMessageWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - sendjsontourl] action in emptyMessage widget.
  String? messagesListJson;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
