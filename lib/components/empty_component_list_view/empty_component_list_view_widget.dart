import 'package:knexattendant/flutter_flow/flutter_flow_theme.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_util.dart';
import 'package:knexattendant/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'empty_component_list_view_model.dart';
export 'empty_component_list_view_model.dart';

class EmptyComponentListViewWidget extends StatefulWidget {
  const EmptyComponentListViewWidget({super.key});

  @override
  State<EmptyComponentListViewWidget> createState() =>
      _EmptyComponentListViewWidgetState();
}

class _EmptyComponentListViewWidgetState
    extends State<EmptyComponentListViewWidget> {
  late EmptyComponentListViewModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EmptyComponentListViewModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        decoration: BoxDecoration(),
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 50.0, 0.0, 0.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.layers_clear_sharp,
                color: FlutterFlowTheme.of(context).secondaryText,
                size: 72.0,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
                child: Text(
                  'No Tickets',
                  style: FlutterFlowTheme.of(context).headlineMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).headlineMediumFamily,
                        letterSpacing: 0.0,
                        useGoogleFonts: !FlutterFlowTheme.of(context)
                            .headlineMediumIsCustom,
                      ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                child: Text(
                  'No tickets found',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily:
                            FlutterFlowTheme.of(context).labelMediumFamily,
                        letterSpacing: 0.0,
                        useGoogleFonts:
                            !FlutterFlowTheme.of(context).labelMediumIsCustom,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
