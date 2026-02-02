import 'package:knexattendant/auth/firebase_auth/auth_util.dart';
import 'package:knexattendant/components/messages_widget.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_icon_button.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_theme.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:knexattendant/custom_code/actions/index.dart' as actions;
import 'chat_page_widget.dart' show ChatPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChatPageModel extends FlutterFlowModel<ChatPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for messages component.
  late MessagesModel messagesModel;
  // State field(s) for messageText widget.
  FocusNode? messageTextFocusNode;
  TextEditingController? messageTextTextController;
  String? Function(BuildContext, String?)? messageTextTextControllerValidator;
  // Stores action output result for [Custom Action - sendjsontourl] action in IconButton widget.
  String? responseMessage;

  @override
  void initState(BuildContext context) {
    messagesModel = createModel(context, () => MessagesModel());
  }

  @override
  void dispose() {
    messagesModel.dispose();
    messageTextFocusNode?.dispose();
    messageTextTextController?.dispose();
  }
}
