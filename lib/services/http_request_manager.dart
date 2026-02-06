import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

export 'dart:async' show StreamController;

/// HTTP Request Priority levels
enum RequestPriority {
  /// Critical requests that should be processed immediately
  critical,
  /// Normal priority requests
  normal,
  /// Background/refresh requests that can be delayed
  background,
}

/// Represents a queued HTTP request
class _QueuedRequest {
  final String id;
  final Future<http.Response> Function() execute;
  final RequestPriority priority;
  final Completer<http.Response> completer;
  final DateTime enqueuedAt;
  final String description;

  _QueuedRequest({
    required this.id,
    required this.execute,
    required this.priority,
    required this.completer,
    required this.description,
  }) : enqueuedAt = DateTime.now();
}

/// HTTP Request Manager with NMI-like mechanism
/// 
/// This manager ensures that HTTP requests are processed sequentially
/// to prevent race conditions and resource conflicts. Similar to NMI
/// (Non-Maskable Interrupt), critical requests can be prioritized.
class HttpRequestManager {
  static final HttpRequestManager _instance = HttpRequestManager._internal();
  factory HttpRequestManager() => _instance;
  HttpRequestManager._internal();

  // Queue of pending requests
  final List<_QueuedRequest> _queue = [];
  
  // Currently processing request
  bool _isProcessing = false;
  
  // Track active requests in flight
  int _activeRequests = 0;
  
  // Stream controller for request state changes
  final _requestStateController = StreamController<bool>.broadcast();
  
  // Statistics
  int _totalProcessed = 0;
  int _totalQueued = 0;
  
  // Configuration
  final Duration _defaultTimeout = const Duration(seconds: 30);
  final Duration _maxQueueWaitTime = const Duration(minutes: 2);
  
  /// Stream that emits true when requests are in flight, false when idle
  Stream<bool> get requestStateStream => _requestStateController.stream;
  
  /// Check if there are any active HTTP requests in flight
  bool get hasActiveRequests => _activeRequests > 0;
  
  /// Get the number of active requests
  int get activeRequestCount => _activeRequests;
  
  // Logging configuration
  bool verboseLogging = true;
  bool logFullResponseBody = true;
  int maxResponseBodyLength = 10000; // Characters to log

  /// Get statistics about the request queue
  Map<String, dynamic> get statistics => {
    'queueLength': _queue.length,
    'isProcessing': _isProcessing,
    'totalProcessed': _totalProcessed,
    'totalQueued': _totalQueued,
  };

  /// Execute an HTTP POST request with queuing
  Future<http.Response> post({
    required Uri uri,
    required Map<String, String> headers,
    required dynamic body,
    RequestPriority priority = RequestPriority.normal,
    String description = 'POST request',
    Duration? timeout,
  }) async {
    return _enqueueRequest(
      execute: () async {
        final requestBody = body is String ? body : jsonEncode(body);
        _logRequest('POST', uri, headers, requestBody);
        
        final response = await http.post(
          uri,
          headers: headers,
          body: requestBody,
        ).timeout(timeout ?? _defaultTimeout);
        
        _logResponse(response);
        return response;
      },
      priority: priority,
      description: description,
    );
  }

  /// Execute an HTTP GET request with queuing
  Future<http.Response> get({
    required Uri uri,
    Map<String, String>? headers,
    RequestPriority priority = RequestPriority.normal,
    String description = 'GET request',
    Duration? timeout,
  }) async {
    return _enqueueRequest(
      execute: () async {
        _logRequest('GET', uri, headers ?? {}, null);
        
        final response = await http.get(
          uri,
          headers: headers,
        ).timeout(timeout ?? _defaultTimeout);
        
        _logResponse(response);
        return response;
      },
      priority: priority,
      description: description,
    );
  }

  /// Execute a raw HTTP request with full control
  Future<http.Response> execute({
    required Future<http.Response> Function() request,
    RequestPriority priority = RequestPriority.normal,
    String description = 'Custom request',
  }) async {
    return _enqueueRequest(
      execute: request,
      priority: priority,
      description: description,
    );
  }

  /// Enqueue a request and process the queue
  Future<http.Response> _enqueueRequest({
    required Future<http.Response> Function() execute,
    required RequestPriority priority,
    required String description,
  }) async {
    final completer = Completer<http.Response>();
    final requestId = '${DateTime.now().millisecondsSinceEpoch}_${_totalQueued++}';
    
    final queuedRequest = _QueuedRequest(
      id: requestId,
      execute: execute,
      priority: priority,
      completer: completer,
      description: description,
    );

    // Insert into queue based on priority
    _insertByPriority(queuedRequest);
    
    if (verboseLogging) {
      print('[HTTP_MANAGER] Request queued: $description (ID: $requestId, Priority: $priority, Queue length: ${_queue.length})');
    }

    // Process queue
    _processQueue();

    // Return future that completes when request is processed
    return completer.future;
  }

  /// Insert request into queue based on priority
  void _insertByPriority(_QueuedRequest request) {
    // Critical requests go to the front, others to the back
    if (request.priority == RequestPriority.critical) {
      // Insert after other critical requests but before normal/background
      int insertIndex = _queue.indexWhere((r) => r.priority != RequestPriority.critical);
      if (insertIndex == -1) {
        _queue.add(request);
      } else {
        _queue.insert(insertIndex, request);
      }
    } else if (request.priority == RequestPriority.normal) {
      // Insert after critical and normal, but before background
      int insertIndex = _queue.indexWhere((r) => r.priority == RequestPriority.background);
      if (insertIndex == -1) {
        _queue.add(request);
      } else {
        _queue.insert(insertIndex, request);
      }
    } else {
      // Background requests go to the end
      _queue.add(request);
    }
  }

  /// Process the request queue
  Future<void> _processQueue() async {
    if (_isProcessing || _queue.isEmpty) return;

    _isProcessing = true;

    while (_queue.isNotEmpty) {
      // Get next request
      final request = _queue.removeAt(0);
      
      // Check if request has been waiting too long
      final waitTime = DateTime.now().difference(request.enqueuedAt);
      if (waitTime > _maxQueueWaitTime) {
        if (verboseLogging) {
          print('[HTTP_MANAGER] Request timed out in queue: ${request.description} (waited ${waitTime.inSeconds}s)');
        }
        request.completer.completeError(
          TimeoutException('Request timed out while waiting in queue', _maxQueueWaitTime),
        );
        continue;
      }

      if (verboseLogging) {
        print('[HTTP_MANAGER] Processing request: ${request.description} (ID: ${request.id}, waited ${waitTime.inMilliseconds}ms)');
      }

      // Increment active requests counter
      _activeRequests++;
      if (_activeRequests == 1) {
        _requestStateController.add(true); // Emit busy state
      }

      try {
        // Execute the request
        final response = await request.execute();
        
        if (!request.completer.isCompleted) {
          request.completer.complete(response);
        }
        
        _totalProcessed++;
        
        if (verboseLogging) {
          print('[HTTP_MANAGER] Request completed: ${request.description} (ID: ${request.id})');
        }
      } catch (e, stackTrace) {
        if (!request.completer.isCompleted) {
          request.completer.completeError(e, stackTrace);
        }
        
        if (verboseLogging) {
          print('[HTTP_MANAGER] Request failed: ${request.description} (ID: ${request.id}), Error: $e');
        }
      } finally {
        // Decrement active requests counter
        _activeRequests--;
        if (_activeRequests == 0) {
          _requestStateController.add(false); // Emit idle state
        }
      }

      // Small delay between requests to prevent overwhelming the server
      if (_queue.isNotEmpty) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    _isProcessing = false;
    
    if (verboseLogging && _totalProcessed % 10 == 0) {
      print('[HTTP_MANAGER] Stats: $_totalProcessed processed, $_totalQueued total queued');
    }
  }

  /// Clear all pending requests
  void clearQueue({String? reason}) {
    final count = _queue.length;
    for (final request in _queue) {
      if (!request.completer.isCompleted) {
        request.completer.completeError(
          Exception('Request cancelled${reason != null ? ': $reason' : ''}'),
        );
      }
    }
    _queue.clear();
    if (verboseLogging && count > 0) {
      print('[HTTP_MANAGER] Queue cleared: $count requests cancelled${reason != null ? ' ($reason)' : ''}');
    }
  }

  /// Dispose resources
  void dispose() {
    _requestStateController.close();
  }

  /// Log HTTP request details
  void _logRequest(String method, Uri uri, Map<String, String> headers, String? body) {
    if (!verboseLogging) return;
    
    print('');
    print('╔══════════════════════════════════════════════════════════════╗');
    print('║                    HTTP REQUEST                              ║');
    print('╠══════════════════════════════════════════════════════════════╣');
    print('║ Method:  $method');
    print('║ URI:     $uri');
    print('║ Headers: ${jsonEncode(headers)}');
    if (body != null) {
      final truncatedBody = body.length > 500 
          ? '${body.substring(0, 500)}... (${body.length} chars)' 
          : body;
      print('║ Body:    $truncatedBody');
    }
    print('╚══════════════════════════════════════════════════════════════╝');
  }

  /// Log HTTP response details
  void _logResponse(http.Response response) {
    if (!verboseLogging) return;
    
    String bodyToLog = response.body;
    if (logFullResponseBody && bodyToLog.length > maxResponseBodyLength) {
      bodyToLog = '${bodyToLog.substring(0, maxResponseBodyLength)}... (${response.body.length} chars total)';
    } else if (!logFullResponseBody) {
      bodyToLog = '<${response.body.length} chars - logging disabled>';
    }

    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;
    final statusIcon = isSuccess ? '✓' : '✗';
    
    print('');
    print('╔══════════════════════════════════════════════════════════════╗');
    print('║                    HTTP RESPONSE $statusIcon                           ║');
    print('╠══════════════════════════════════════════════════════════════╣');
    print('║ Status:  ${response.statusCode} ${response.reasonPhrase ?? ""}');
    print('║ Headers: ${jsonEncode(response.headers)}');
    print('║ Body:');
    // Pretty print JSON if possible
    try {
      final jsonData = jsonDecode(response.body);
      final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonData);
      final lines = prettyJson.split('\n');
      for (final line in lines.take(50)) { // Limit to 50 lines
        print('║   $line');
      }
      if (lines.length > 50) {
        print('║   ... (${lines.length - 50} more lines)');
      }
    } catch (_) {
      // Not JSON, print as-is
      final lines = bodyToLog.split('\n');
      for (final line in lines.take(50)) {
        print('║   $line');
      }
      if (lines.length > 50) {
        print('║   ... (${lines.length - 50} more lines)');
      }
    }
    print('╚══════════════════════════════════════════════════════════════╝');
    print('');
  }
}

/// Custom TimeoutException for queue timeouts
class TimeoutException implements Exception {
  final String message;
  final Duration duration;
  
  TimeoutException(this.message, this.duration);
  
  @override
  String toString() => 'TimeoutException: $message after ${duration.inSeconds}s';
}
