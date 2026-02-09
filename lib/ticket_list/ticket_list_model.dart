import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:async';
import '/index.dart';
import 'ticket_list_widget.dart' show TicketListWidget;
import 'package:flutter/material.dart';
import '../services/http_request_manager.dart';

class TicketListModel extends FlutterFlowModel<TicketListWidget> {
  ///  Local state fields for this page.

  String status = 'Arrival';

  double posx = 0.0;

  List<String> tickets = [];
  void addToTickets(String item) => tickets.add(item);
  void removeFromTickets(String item) => tickets.remove(item);
  void removeAtIndexFromTickets(int index) => tickets.removeAt(index);
  void insertAtIndexInTickets(int index, String item) =>
      tickets.insert(index, item);
  void updateTicketsAtIndex(int index, Function(String) updateFn) =>
      tickets[index] = updateFn(tickets[index]);

  List<double> posxx = [];
  void addToPosxx(double item) => posxx.add(item);
  void removeFromPosxx(double item) => posxx.remove(item);
  void removeAtIndexFromPosxx(int index) => posxx.removeAt(index);
  void insertAtIndexInPosxx(int index, double item) =>
      posxx.insert(index, item);
  void updatePosxxAtIndex(int index, Function(double) updateFn) =>
      posxx[index] = updateFn(posxx[index]);

  bool isLoadedQueryList = false;

  String? statusQuery;

  bool boolHandlerLoops = false;

  String prvStatus = ' ';

  String tmpBuffer = ' ';

  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer2;
  // Stores action output result for [Custom Action - sendjsontourl] action in TicketList widget.
  String? ticketlistA;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  // Stores action output result for [Custom Action - sendjsontourl] action in slidableTileTicketListArrival widget.
  String? setToProcessing;
  // Stores action output result for [Custom Action - sendjsontourl] action in slidableTileTicketListDeparture widget.
  String? setToProcessingDeparture;

  /// Intelligent polling state
  bool _isVisible = true;
  bool _isPaused = false;
  bool _pendingRefresh = false;
  StreamSubscription<bool>? _httpStateSubscription;
  DateTime? _lastFetchTime;

  /// Minimum interval between fetches (to prevent too frequent calls)
  static const Duration _minFetchInterval = Duration(seconds: 3);

  /// Getters for polling state
  bool get isVisible => _isVisible;
  bool get isPaused => _isPaused;
  bool get canFetch => _isVisible && !_isPaused && !_isHttpBusy;
  bool get hasPendingRefresh => _pendingRefresh;
  bool _isHttpBusy = false;

  @override
  void initState(BuildContext context) {
    // Subscribe to HTTP request state changes
    _httpStateSubscription =
        HttpRequestManager().requestStateStream.listen((isBusy) {
      _isHttpBusy = isBusy;
      if (isBusy) {
        // Pause polling when HTTP requests are in flight
        pausePolling();
      } else {
        // Resume polling when HTTP requests complete
        resumePolling();
      }
    });
  }

  @override
  void dispose() {
    instantTimer2?.cancel();
    tabBarController?.dispose();
    _httpStateSubscription?.cancel();
  }

  /// Called when the widget becomes visible
  void onResume() {
    _isVisible = true;
    print('[TicketList] Screen resumed');

    // If we have a pending refresh or data is stale, refresh immediately
    if (_pendingRefresh || _isDataStale()) {
      _pendingRefresh = false;
      // Trigger immediate refresh
      _triggerImmediateRefresh();
    } else {
      resumePolling();
    }
  }

  /// Called when the widget is no longer visible
  void onPause() {
    _isVisible = false;
    _pendingRefresh = true; // Mark that we need a refresh when we come back
    print('[TicketList] Screen paused');
    pausePolling();
  }

  /// Pause the polling timer
  void pausePolling() {
    if (!_isPaused) {
      _isPaused = true;
      print(
          '[TicketList] Polling paused (HTTP busy: $_isHttpBusy, Visible: $_isVisible)');
    }
  }

  /// Resume the polling timer
  void resumePolling() {
    if (_isPaused && _isVisible && !_isHttpBusy) {
      _isPaused = false;
      print('[TicketList] Polling resumed');
    }
  }

  /// Check if data is stale (last fetch was more than 10 seconds ago)
  bool _isDataStale() {
    if (_lastFetchTime == null) return true;
    return DateTime.now().difference(_lastFetchTime!) >
        const Duration(seconds: 10);
  }

  /// Update last fetch time
  void updateLastFetchTime() {
    _lastFetchTime = DateTime.now();
  }

  /// Check if we can perform a fetch (respects minimum interval)
  bool shouldFetch() {
    if (!canFetch) return false;

    // Check minimum interval
    if (_lastFetchTime != null) {
      final timeSinceLastFetch = DateTime.now().difference(_lastFetchTime!);
      if (timeSinceLastFetch < _minFetchInterval) {
        return false;
      }
    }

    return true;
  }

  /// Trigger an immediate refresh ( bypasses timer)
  void _triggerImmediateRefresh() {
    print('[TicketList] Triggering immediate refresh');
    // Cancel existing timer and restart
    instantTimer2?.cancel();
    instantTimer2 = null;
    _isPaused = false;
    _lastFetchTime = null; // Force the fetch
  }

  /// Manually trigger a refresh
  void requestRefresh() {
    _pendingRefresh = true;
    if (_isVisible && !_isHttpBusy) {
      _triggerImmediateRefresh();
    }
  }

  /// Called when navigating to a detail page - pauses polling until return
  void onNavigateToDetail() {
    print('[TicketList] Navigating to detail - cancelling polling timer');
    _isPaused = true;
    _pendingRefresh = true; // Will refresh when we come back
    // Cancel the timer to prevent any pending callbacks
    instantTimer2?.cancel();
    instantTimer2 = null;
  }

  /// Called when returning from detail page
  void onReturnFromDetail() {
    print('[TicketList] Returned from detail - will refresh');
    _isPaused = false;
    _pendingRefresh = false;
    _lastFetchTime = null; // Force a refresh
    // Note: Timer will be restarted by the widget's _startIntelligentPolling
  }
}
