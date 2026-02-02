import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import 'package:knexattendant/auth/firebase_auth/auth_util.dart';

List<String> jsontoArray(String jsonString) {
  final String _fnName = "jsontoArray";
  print('FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: START');

  String printableJsonString;
  if (jsonString.length > 100) {
    printableJsonString =
        '"${jsonString.substring(0, 100)}..." (length: ${jsonString.length})';
  } else {
    printableJsonString = '"$jsonString"';
  }
  print(
    'FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: Input jsonString: $printableJsonString',
  );

  try {
    print('FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: Attempting jsonDecode.');
    final dynamic decodedJson = jsonDecode(jsonString);
    print(
      'FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: jsonDecode successful. Type: ${decodedJson.runtimeType}.',
    );

    if (decodedJson is! List) {
      print(
        'FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: Decoded JSON is not a List. Actual type: ${decodedJson.runtimeType}. Returning [].',
      );
      print('FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: END (not a list)');
      return [];
    }

    final List<dynamic> jsonList = decodedJson;
    print(
      'FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: Decoded JSON is a List. Items: ${jsonList.length}.',
    );

    List<String> stringList = jsonList.map((item) {
      if (item is String) {
        return item;
      } else if (item is Map || item is List) {
        return jsonEncode(item);
      } else {
        return item.toString();
      }
    }).toList();

    print(
      'FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: Mapping to List<String> complete. Result size: ${stringList.length}.',
    );
    print('FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: END (success)');
    return stringList;
  } catch (e, s) {
    print('FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: ERROR CAUGHT.');
    print('FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: Error Type: ${e.runtimeType}');
    print('FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: Error: $e');
    print('FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: Stacktrace: $s');

    String errorMessage = 'Error: $e';
    if (errorMessage.length > 200) {
      errorMessage = errorMessage.substring(0, 200) + "...";
    }

    print('FF_CUSTOM_FUNC_DEBUG: $_fnName: L4: END (error)');
    return [errorMessage];
  }
}

String getkeyfromjsonstring(String string, String key) {
  print("*--*-*-*-*-*--*-*-*--*-*-*---*");
  print("Input JSON String: $string");
  print("Target Key: $key");
  print("*..*..*.*.*..*.*.*.*..*.*.*..*.");

  // The parameter 'string' is non-nullable (String string).
  // The 'string == null' check would be true only if this function is called from a context
  // that bypasses Dart's static typing (e.g., dynamic invocation or from JavaScript).
  // In standard Dart, a non-nullable String cannot be null.
  // However, keeping it as it might be a FlutterFlow defensive check.
  if (string.trim().isEmpty || string.length < 2) {
    print("Input string is null, empty, or too short. Returning empty string.");
    return "";
  }

  try {
    final dynamic jsonData = jsonDecode(string);

    // Recursive function to find the key
    // This function is defined above the "MODIFY CODE ONLY BELOW THIS LINE" marker in the original problem structure,
    // so it's assumed to be outside the modification scope for this request.
    // It's included here for completeness of the `getkeyfromjsonstring` function.
    dynamic findKeyRecursively(dynamic currentJson, String targetKey) {
      if (currentJson is Map<String, dynamic>) {
        if (currentJson.containsKey(targetKey)) {
          return currentJson[targetKey];
        }
        for (final value in currentJson.values) {
          final dynamic result = findKeyRecursively(value, targetKey);
          if (result != null ||
              (currentJson.containsKey(targetKey) &&
                  currentJson[targetKey] == null &&
                  result == null)) {
            // The condition `(currentJson.containsKey(targetKey) && currentJson[targetKey] == null && result == null)` part is tricky.
            // If a key exists with value null, like `{"myKey": null}` and `targetKey` is `myKey`, `currentJson[targetKey]` would be null.
            // The original `result != null` would miss this if we want to return explicit JSON null.
            // However, the existing recursive structure returns `null` if the key's value is `null`,
            // or if the key is not found in a deeper branch. This is handled later.
            // The provided original code for recursion is: `if (result != null) return result;`
            // Sticking to that simplicity: if a search in a branch yields a non-null value, it's found.
            // If the direct key lookup `currentJson[targetKey]` yields `null`, that `null` is returned.
            if (result != null) {
              return result;
            }
            // Added check: If the specific key whose value is null is found, this path might not be hit if we rely on result!=null
            // Let's assume the original recursive function implies that if currentJson[targetKey] is null, it's a valid found value (null).
            // The original structure seems robust for finding values, including nulls.
          }
        }
      } else if (currentJson is List<dynamic>) {
        for (final item in currentJson) {
          final dynamic result = findKeyRecursively(item, targetKey);
          if (result != null) {
            return result;
          }
        }
      }
      return null; // Key not found in this branch
    }

    final dynamic foundValue = findKeyRecursively(jsonData, key);
    String returnValue;

    if (foundValue == null) {
      // This case covers:
      // 1. Key not found in the JSON structure.
      // 2. Key was found, but its value was JSON 'null'.
      // In both scenarios, returning an empty string as per original logic.
      returnValue = "";
    } else if (foundValue is String) {
      // If the found value is a string, encode it as a JSON string.
      // e.g., "hello" becomes "\"hello\"".
      // This ensures the returned string is a valid JSON representation of the original string.
      returnValue = jsonEncode(foundValue);
    } else if (foundValue is num || foundValue is bool) {
      // For numbers and booleans, jsonEncode converts them to their string representations
      // which are also valid JSON values (e.g., 123 -> "123", true -> "true").
      returnValue = jsonEncode(foundValue);
    } else if (foundValue is List || foundValue is Map) {
      // If the found value is a List or Map, convert it back to a JSON string.
      // jsonEncode handles quoting of any string values within these structures correctly.
      // e.g., {'name': 'Alice'} becomes '{"name":"Alice"}'
      // e.g., ['apple', 'banana'] becomes '["apple","banana"]'
      try {
        returnValue = jsonEncode(foundValue);
      } catch (e) {
        print("Error encoding List/Map to JSON string: $e. Value: $foundValue");
        returnValue = ""; // Fallback to empty string on encoding error
      }
    } else {
      // For any other unexpected type (e.g., custom objects not standard in JSON).
      // Convert the value to string using .toString(), then encode that string as a JSON string.
      // e.g., if foundValue.toString() is "Instance of MyClass",
      // returnValue will be "\"Instance of MyClass\"".
      print(
        "Unexpected type found: ${foundValue.runtimeType}. Converting its .toString() representation to a JSON string. Value: $foundValue",
      );
      try {
        returnValue = jsonEncode(foundValue.toString());
      } catch (e) {
        print(
          "Error encoding .toString() of unexpected type to JSON string: $e. Value: $foundValue",
        );
        returnValue = ""; // Fallback
      }
    }

    print("___________________________");
    // $returnValue is already a string. If it's a JSON string like "\"hello\"" or "{\"key\":\"value\"}",
    // this print statement will show it as is, wrapped in the print function's outer quotes.
    print("Final Return Value (String): \"$returnValue\"");
    return returnValue;
  } catch (e) {
    print("Error decoding JSON or processing: $e");
    print("Problematic JSON string: $string");
    return ""; // Return empty string in case of error
  }
}

String replaceSubstringCaseInsensitive(
  String original,
  String oldSubstr,
  String newSubstr,
) {
  return original.replaceAll(
    RegExp(oldSubstr, caseSensitive: false),
    newSubstr,
  );
}

String extractTime(String timeStr) {
  if (timeStr == null || timeStr.trim().isEmpty) {
    print(
      "[INPUT_EVALUATION] ⛔ Input is null or empty. Aborting processing.",
    );
    return jsonEncode({
      'error': 'NULL_OR_EMPTY_INPUT',
      'message': 'The input string was null or empty.',
      'original_input': timeStr,
      'stage': 'input_validation',
    });
  }
  try {
    String
    stringToParse; // This will hold the actual date string to be processed.

    // Step 1: Determine the actual date string (stringToParse) from timeStr.
    // This handles the two scenarios: timeStr is JSON-encoded string, or timeStr is a direct string.
    try {
      print(
        "[INPUT_EVALUATION] Attempting to decode input as JSON: \"$timeStr\"",
      );
      dynamic decodedJson = jsonDecode(timeStr);

      if (decodedJson is String) {
        stringToParse = decodedJson;
        print(
          "[INPUT_EVALUATION] ✅ Input is a JSON-encoded string. Using decoded value: \"$stringToParse\"",
        );
      } else {
        // Input is valid JSON, but not a string (e.g. "123", "true", "{}").
        // This is an invalid format for a date string.
        print(
          "[INPUT_EVALUATION] ⛔ Input decoded as JSON, but the value is not a string. Original input: \"$timeStr\", Decoded type: ${decodedJson.runtimeType}",
        );
        return jsonEncode({
          'error': 'INVALID_JSON_CONTENT_TYPE',
          'message':
              'Input was JSON, but the decoded content was not a string representing a date/time.',
          'original_input': timeStr, // The raw input string
          'decoded_value_type': decodedJson.runtimeType.toString(),
          'stage': 'input_evaluation',
        });
      }
    } catch (e) {
      // jsonDecode failed, assume timeStr is the direct date/time string.
      stringToParse = timeStr;
      print(
        "[INPUT_EVALUATION] ℹ️ Input is not a valid JSON string (or an error occurred during decode), treating as a direct date/time string. Input: \"$stringToParse\". Decode error detail: $e",
      );
    }

    // --- Original processing pipeline starts here, using stringToParse ---
    // The variable 'timestring' from original code is now 'stringToParse'.

    // Adjusted log numbering (e.g., from [1/5] to [1/6] to account for input eval)
    print("[1/6] Starting date/time processing for: \"$stringToParse\"");

    // --- DateTime Parsing Block ---
    DateTime parsedDate;
    try {
      print("[2/6] Attempting to parse ISO string...");
      parsedDate = DateTime.parse(stringToParse);
      print("✅ Successfully parsed date: $parsedDate");
    } catch (parseError, stackTrace) {
      print("⛔ Critical parse error: $parseError for input \"$stringToParse\"");
      print("Stack trace:\n$stackTrace");
      return jsonEncode({
        'error': 'DATE_PARSE_FAILURE',
        'message': 'Failed to parse input string as DateTime',
        'details': parseError.toString(),
        'input_to_parse':
            stringToParse, // What was actually attempted for parsing
        'original_parameter': timeStr, // The raw input parameter
        'stage': 'initial_parsing',
      });
    }

    // --- UTC Conversion Block ---
    DateTime utcDate;
    try {
      print("[3/6] Converting to UTC...");
      utcDate = parsedDate.toUtc();
      print("✅ UTC conversion successful: $utcDate");
    } catch (conversionError, stackTrace) {
      print("⛔ UTC conversion failed: $conversionError");
      print("Stack trace:\n$stackTrace");
      return jsonEncode({
        'error': 'UTC_CONVERSION_FAILURE',
        'message': 'Failed to convert local date to UTC',
        'original_date': parsedDate.toString(),
        'details': conversionError.toString(),
        'stage': 'utc_conversion',
      });
    }

    // --- Date Formatting Block ---
    String formattedDate;
    try {
      print("[4/6] Formatting date...");
      String month = DateFormat('MMMM').format(utcDate);
      formattedDate =
          '${month} '
          '${utcDate.day}, ${utcDate.year}';
      print("✅ Date formatted: $formattedDate");
    } catch (formatError, stackTrace) {
      print("⛔ Date formatting failed: $formatError");
      print("Stack trace:\n$stackTrace");
      return jsonEncode({
        'error': 'DATE_FORMAT_FAILURE',
        'message': 'Failed to format date components',
        'utc_date': utcDate.toString(),
        'details': formatError.toString(),
        'stage': 'date_formatting',
      });
    }

    // --- Time Formatting Block ---
    String formattedTime;
    try {
      print("[5/6] Formatting time...");
      final hour = utcDate.hour;
      final period = hour >= 12 ? 'PM' : 'AM';
      final twelveHour = hour % 12 == 0 ? 12 : hour % 12;

      formattedTime =
          '${twelveHour.toString().padLeft(2, '0')}:'
          '${utcDate.minute.toString().padLeft(2, '0')} $period';
      print("✅ Time formatted: $formattedTime");
    } catch (formatError, stackTrace) {
      print("⛔ Time formatting failed: $formatError");
      print("Stack trace:\n$stackTrace");
      return jsonEncode({
        'error': 'TIME_FORMAT_FAILURE',
        'message': 'Failed to format time components',
        'utc_date': utcDate.toString(),
        'details': formatError.toString(),
        'stage': 'time_formatting',
      });
    }

    // --- Time Difference Calculation ---
    String timeDifference;
    try {
      print("[6/6] Calculating time difference...");
      final now = DateTime.now().toUtc();
      final difference = now.difference(utcDate);

      final days = difference.inDays;
      final hours = difference.inHours % 24;
      final minutes = difference.inMinutes % 60;
      final seconds = difference.inSeconds % 60;

      timeDifference =
          '${days.toString().padLeft(2, '0')}d '
          '${hours.toString().padLeft(2, '0')}h '
          '${minutes.toString().padLeft(2, '0')}m '
          '${seconds.toString().padLeft(2, '0')}s';
      print("✅ Time difference calculated: $timeDifference");
    } catch (differenceError, stackTrace) {
      print("⛔ Time difference calculation failed: $differenceError");
      print("Stack trace:\n$stackTrace");
      return jsonEncode({
        'error': 'TIME_DIFFERENCE_FAILURE',
        'message': 'Failed to calculate time difference',
        'utc_date': utcDate.toString(),
        'details': differenceError.toString(),
        'stage': 'time_difference',
      });
    }

    // --- Final Output Assembly ---
    try {
      print("🔄 Assembling final result...");
      final result = {
        'date': formattedDate,
        'time': formattedTime,
        'time_difference': timeDifference,
        'utc_timestamp': utcDate.toIso8601String(),
        'success': true,
        'input_processed': stringToParse, // Clarify what was processed
        'original_parameter': timeStr, // And the original input parameter
      };
      print(
        "🎉 Full processing completed successfully for input_processed \"$stringToParse\" (original_parameter: \"$timeStr\")",
      );
      return jsonEncode(result);
    } catch (assemblyError, stackTrace) {
      print("⛔ Result assembly failed: $assemblyError");
      print("Stack trace:\n$stackTrace");
      return jsonEncode({
        'error': 'RESULT_ASSEMBLY_FAILURE',
        'message': 'Failed to create final result object',
        'formatted_date': formattedDate,
        'formatted_time': formattedTime,
        'time_difference': timeDifference,
        'details': assemblyError.toString(),
        'stage': 'result_assembly',
      });
    }
  } catch (unexpectedError, stackTrace) {
    // This is the outermost catch block. It's hit if an error occurs outside of
    // the specific try-catch blocks above (e.g., an OutOfMemoryError, or an error
    // in the input evaluation logic not caught by its specific try-catch).
    print(
      "💥 Unexpected top-level error: $unexpectedError. Original input parameter: \"$timeStr\"",
    );
    print("Stack trace:\n$stackTrace");
    return jsonEncode({
      'error': 'UNEXPECTED_PIPELINE_FAILURE', // More specific error code
      'message': 'An unexpected error occurred during the processing pipeline.',
      'details': unexpectedError.toString(),
      'original_input_parameter': timeStr, // The raw input parameter
      'stage': 'unknown_pipeline_stage', // More specific stage
    });
  }
}

String parseStringTimeToMinutesString(String dateString) {
  const String errorReturnValue = '0m';

  try {
    // Handle null input.
    if (dateString.trim().isEmpty) {
      return errorReturnValue;
    }

    List<String> parts = dateString.split(' ');

    // Check if the string is in the expected structure "Xd Yh Zm Ws" (4 components).
    if (parts.length != 4) {
      return errorReturnValue;
    }

    // --- Days part validation ---
    String dayPartStr = parts[0];
    // Check suffix and ensure there's a numeric part (e.g., not just "d")
    if (!dayPartStr.endsWith('d') || dayPartStr.length == 1) {
      return errorReturnValue;
    }
    String numericDayStr = dayPartStr.substring(0, dayPartStr.length - 1);
    int days = int.parse(numericDayStr); // int.parse can throw FormatException

    // --- Hours part validation ---
    String hourPartStr = parts[1];
    if (!hourPartStr.endsWith('h') || hourPartStr.length == 1) {
      return errorReturnValue;
    }
    String numericHourStr = hourPartStr.substring(0, hourPartStr.length - 1);
    int hours = int.parse(
      numericHourStr,
    ); // int.parse can throw FormatException

    // --- Minutes part validation ---
    String minutePartStr = parts[2];
    if (!minutePartStr.endsWith('m') || minutePartStr.length == 1) {
      return errorReturnValue;
    }
    String numericMinuteStr = minutePartStr.substring(
      0,
      minutePartStr.length - 1,
    );
    int minutes = int.parse(
      numericMinuteStr,
    ); // int.parse can throw FormatException

    // --- Seconds part validation ---
    String secondPartStr = parts[3];
    if (!secondPartStr.endsWith('s') || secondPartStr.length == 1) {
      return errorReturnValue;
    }
    String numericSecondStr = secondPartStr.substring(
      0,
      secondPartStr.length - 1,
    );
    int seconds = int.parse(
      numericSecondStr,
    ); // int.parse can throw FormatException

    // Ensure all duration components are non-negative.
    if (days < 0 || hours < 0 || minutes < 0 || seconds < 0) {
      return errorReturnValue;
    }

    // If all parsing and validation checks pass, calculate total minutes
    // from the hours and minutes components, and return in "XXm" format.
    return '${(hours * 60) + minutes}m';
  } catch (e) {
    // This catch block handles:
    // - FormatException from int.parse() if numeric parts are not valid integers (e.g., "abc", "1x1d").
    // - Any other unexpected errors during the process (e.g. if dateString was null and the explicit check was removed).
    return errorReturnValue;
  }
}

String tostr(String element) {
  print(element.toString());
  return element.toString().replaceAll(RegExp(r'[\"]'), '');
}

int stringDateToMillisecondsInt(String? stringDate) {
  // transform "00d 00h 00m 00s" to integer milliseconds
  if (stringDate == null || stringDate.trim().isEmpty) {
    return 0;
  }

  List<String> parts = stringDate.split(' ');
  if (parts.length < 4) {
    return 0;
  }

  try {
    int days = int.parse(parts[0].replaceAll('d', ''));
    int hours = int.parse(parts[1].replaceAll('h', ''));
    int minutes = int.parse(parts[2].replaceAll('m', ''));
    int seconds = int.parse(parts[3].replaceAll('s', ''));

    int totalMilliseconds =
        days * 24 * 60 * 60 * 1000 +
        hours * 60 * 60 * 1000 +
        minutes * 60 * 1000 +
        seconds * 1000;

    return totalMilliseconds;
  } catch (e) {
    return 0;
  }
}

String makeArryOfTickets(String jsonArrayString) {
  List<dynamic> decodedJson;
  try {
    decodedJson = jsonDecode(jsonArrayString);
  } catch (e) {
    print("Error decoding JSON: $e");
    return '{"error": "JSON decoding failed"}'; // Return error JSON string
  }

  Map<String, List<Map<String, dynamic>>> ticketsByStatus = {};

  for (var item in decodedJson) {
    if (item is Map<String, dynamic>) {
      String? status = item['status'] as String?; // Get status, handle null
      if (status != null) {
        if (ticketsByStatus.containsKey(status)) {
          ticketsByStatus[status]!.add(item);
        } else {
          ticketsByStatus[status] = [item];
        }
      } else {
        print("Warning: Ticket object missing 'status' field: $item");
        // Option: Decide how to handle tickets without status.
        // You could skip them, or add them to a special 'Unknown Status' category.
      }
    } else {
      print("Array item is not a JSON object (Ticket): $item");
      // Optionally handle non-object items in the array.
    }
  }

  try {
    return jsonEncode(ticketsByStatus); // Convert the map to JSON string
  } catch (e) {
    print("Error encoding to JSON: $e");
    return '{"error": "JSON encoding failed"}'; // Return error JSON string
  }
}

double sumStrings(String? str1, String? str2) {
  // sum strings, if not valid, return 0
  // Check if either string is null or empty
  if (str1 == null || str1.isEmpty || str2 == null || str2.isEmpty) {
    return 0.0;
  }

  try {
    // Try to parse both strings to double
    double num1 = double.parse(str1) ?? 0;
    double num2 = double.parse(str2) ?? 0;

    // Return the sum of the two numbers
    return num1 + num2;
  } catch (e) {
    // If parsing fails, return 0
    return 0.0;
  }
}

String arrayToJson(List<String> stringArray) {
  try {
    if (stringArray.isEmpty) {
      return '[]';
    }
    return jsonEncode(stringArray);
  } catch (e) {
    return 'Error: $e';
  }
}

String tolocaltime(String initialDateString) {
  const int parsedTypeNone = 0;
  const int parsedTypeFullDateTime = 1;
  const int parsedTypeDateOnly = 2;
  const int parsedTypeTimeOnly = 3;

  if (initialDateString.isEmpty) {
    return "Error: No date string provided";
  }

  // --- Preprocessing ---
  String dateString = initialDateString.trim(); // 1. Trim whitespace
  dateString = dateString.replaceAll('"', ''); // 2. Remove double quotes
  dateString = dateString.replaceAll("'", ''); // 2. Remove single quotes
  dateString = dateString.replaceAllMapped(
    RegExp(r'\s+'),
    (match) => ' ',
  ); // 3. Normalize multiple spaces to one

  // Early exit if preprocessing results in an empty string
  if (dateString.isEmpty) {
    return "Error: Date string became empty after preprocessing";
  }
  // --- End Preprocessing ---

  DateTime? dateTime;
  int currentParsedType = parsedTypeNone;

  // --- Stage 1: Try parsing as Time-Only FIRST ---
  if (currentParsedType == parsedTypeNone) {
    const List<String> timeOnlyFormats = [
      'hh:mm:ss a',
      'HH:mm:ss',
      'h:m:s a',
      'H:m:s',
      'hh:mm a',
      'HH:mm',
      'h:m a',
      'H:m',
      'HHmmss',
    ];
    for (String format in timeOnlyFormats) {
      try {
        DateTime parsedTimePart = DateFormat(format).parseLoose(dateString);
        final now = DateTime.now();
        dateTime = DateTime(
          now.year,
          now.month,
          now.day,
          parsedTimePart.hour,
          parsedTimePart.minute,
          parsedTimePart.second,
        );
        currentParsedType = parsedTypeTimeOnly;
        break;
      } catch (_) {
        /* no-op */
      }
    }
  }

  // --- Stage 2: Try parsing as Date-Only (if not already parsed) ---
  if (currentParsedType == parsedTypeNone) {
    const List<String> dateOnlyFormats = [
      'MM/dd/yyyy',
      'dd/MM/yyyy',
      'yyyy-MM-dd',
      'MMM d, yyyy',
      'MMMM d, yyyy',
      'M/d/yyyy',
      'dd.MM.yyyy',
      'yyyy/MM/dd',
      'yyyyMMdd',
      'MM/dd/yy',
      'dd/MM/yy',
      'M/d/yy',
      'MMM d, yy',
      'MMMM d, yy',
      'MMM d',
      'MMMM d',
      'M/d',
    ];
    for (String format in dateOnlyFormats) {
      try {
        DateTime parsedDatePart = DateFormat(format).parseLoose(dateString);
        int year = parsedDatePart.year;
        if (!format.toLowerCase().contains('y')) {
          year = DateTime.now().year;
        }
        dateTime = DateTime(year, parsedDatePart.month, parsedDatePart.day);
        currentParsedType = parsedTypeDateOnly;
        break;
      } catch (_) {
        /* no-op */
      }
    }
  }

  // --- Stage 3: Try parsing as full DateTime or Timestamp (if not already parsed) ---
  if (currentParsedType == parsedTypeNone) {
    // Attempt 3.1: Direct DateTime.parse()
    try {
      dateTime = DateTime.parse(dateString);
      currentParsedType = parsedTypeFullDateTime;
    } catch (_) {
      /* no-op */
    }

    // Attempt 3.2: Numeric Timestamp (if not already parsed by DateTime.parse)
    if (currentParsedType == parsedTypeNone) {
      final numericValue = int.tryParse(
        dateString,
      ); // Use preprocessed dateString
      if (numericValue != null) {
        try {
          // Use preprocessed dateString for length check too
          if (dateString.length == 10) {
            dateTime = DateTime.fromMillisecondsSinceEpoch(
              numericValue * 1000,
              isUtc: true,
            );
          } else if (dateString.length == 13) {
            dateTime = DateTime.fromMillisecondsSinceEpoch(
              numericValue,
              isUtc: true,
            );
          } else {
            DateTime potentialMsDate = DateTime.fromMillisecondsSinceEpoch(
              numericValue,
              isUtc: true,
            );
            if ((numericValue > 0 && potentialMsDate.year > 2800) ||
                (numericValue < 0 &&
                    potentialMsDate.year == 1969 &&
                    numericValue.abs() > Duration.millisecondsPerDay * 30)) {
              dateTime = DateTime.fromMillisecondsSinceEpoch(
                numericValue * 1000,
                isUtc: true,
              );
            } else {
              dateTime = potentialMsDate;
            }
          }
          currentParsedType = parsedTypeFullDateTime;
        } catch (eTimestamp) {
          /* no-op */
        }
      }
    }

    // Attempt 3.3: Common Full Formats (if not already parsed by previous methods in this stage)
    if (currentParsedType == parsedTypeNone) {
      const List<String> commonFullFormats = [
        'MM/dd/yyyy hh:mm:ss a',
        'dd/MM/yyyy hh:mm:ss a',
        'yyyy-MM-dd hh:mm:ss a',
        'MM/dd/yyyy HH:mm:ss',
        'dd/MM/yyyy HH:mm:ss',
        'yyyy-MM-dd HH:mm:ss',
        'yyyy-MM-ddTHH:mm:ss.SSSZ',
        'yyyy-MM-ddTHH:mm:ssZ',
        'yyyy-MM-ddTHH:mm:ss',
        'MMM d, yyyy h:mm:ss a',
        'MMMM d, yyyy h:mm:ss a',
        'MMM d, yyyy h:mm a',
        'MMMM d, yyyy h:mm a',
        'yyyy-MM-dd HH:mm',
        'MM/dd/yyyy HH:mm',
        'dd/MM/yyyy HH:mm',
        'M/d/yyyy H:m:s',
        'M/d/yy H:m:s',
        'M/d/yyyy H:m',
        'M/d/yy H:m',
        'dd.MM.yyyy HH:mm:ss',
      ];
      for (String format in commonFullFormats) {
        try {
          dateTime = DateFormat(format).parseLoose(dateString);
          currentParsedType = parsedTypeFullDateTime;
          break;
        } catch (_) {
          /* no-op */
        }
      }
    }
  }

  // --- Finalization and Formatting ---
  if (dateTime == null || currentParsedType == parsedTypeNone) {
    // Include the *original* string in the error for better user-facing context
    return "Error: Invalid date/time format - Could not parse '$initialDateString'";
  }

  DateTime localDateTime = dateTime.toLocal();

  try {
    switch (currentParsedType) {
      case parsedTypeFullDateTime:
        final DateFormat fullFormatter = DateFormat(
          'EEE, MMM d, yyyy, hh:mm a',
        );
        return fullFormatter.format(localDateTime);
      case parsedTypeDateOnly:
        final DateFormat dateFormatter = DateFormat('MMM d, yyyy');
        return dateFormatter.format(localDateTime);
      case parsedTypeTimeOnly:
        final DateFormat timeFormatter = DateFormat('h:mm a');
        return timeFormatter.format(localDateTime);
      case parsedTypeNone:
      default:
        return "Error: Parsing resulted in an unknown state for '$initialDateString'";
    }
  } catch (e) {
    return "Error: Could not format parsed value for '$initialDateString'. Details: $e";
  }
}
