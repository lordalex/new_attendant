import 'package:knexattendant/auth/firebase_auth/auth_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_theme.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'package:knexattendant/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'empty_message_model.dart';
export 'empty_message_model.dart';

class EmptyMessageWidget extends StatefulWidget {
  const EmptyMessageWidget({
    super.key,
    String? messageJson,
  }) : messageJson = messageJson ?? '{}';

  final String messageJson;

  @override
  State<EmptyMessageWidget> createState() => _EmptyMessageWidgetState();
}

class _EmptyMessageWidgetState extends State<EmptyMessageWidget> {
  late EmptyMessageModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmptyMessageModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.messagesListJson = await actions.sendjsontourl(
        '{}',
        currentJwtToken,
        FFAppConstants.getMessagesURL,
      );
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 1.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 0.0,
              color: FlutterFlowTheme.of(context).primaryBackground,
              offset: const Offset(
                0.0,
                1.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.8,
          height: double.infinity,
          constraints: const BoxConstraints(
            minHeight: 25.0,
            maxHeight: 500.0,
          ),
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).accent2,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(0.0),
            ),
            shape: BoxShape.rectangle,
            border: Border.all(
              width: 2.0,
            ),
          ),
          child: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
              child: Text(
                'NO MESSAGES',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: FlutterFlowTheme.of(context).bodySmallFamily,
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 20.0,
                      letterSpacing: 0.0,
                      fontStyle: FontStyle.italic,
                      useGoogleFonts:
                          !FlutterFlowTheme.of(context).bodySmallIsCustom,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
