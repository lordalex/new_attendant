import 'package:knexattendant/components/messages_widget.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'chat_page_widget.dart' show ChatPageWidget;
import 'package:flutter/material.dart';

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
