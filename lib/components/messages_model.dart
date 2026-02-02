import 'package:knexattendant/components/empty_message_widget.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'messages_widget.dart' show MessagesWidget;
import 'package:flutter/material.dart';

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
