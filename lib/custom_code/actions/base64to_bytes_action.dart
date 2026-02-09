// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:math' as math;

Future<FFUploadedFile> base64toBytesAction(
  String base64, // Changed to String? to handle potential null input
  String fileName,
) async {
  int verbosityLevel = 4;
  const int vNone = 0;
  const int vInfo = 1;
  const int vDebug = 2;
  const int vTrace = 3;
  const int vSpam = 4;
  final String base64Input = base64;
  final String originalInputForLog =
      base64Input.substring(0, math.min(base64Input.length, 100)) ??
          "null_input";
  final bool logSpam = verbosityLevel >= vSpam;

  if (verbosityLevel >= vInfo) {
    print(
      '[V_INFO] base64toBytesAction started. File: "$fileName", Verbosity: $verbosityLevel. Input (first 100): "$originalInputForLog${base64Input.length > 100 ? "..." : ""}"',
    );
  }

  // Check for empty or error input
  if (base64Input.isEmpty ||
      base64Input == "error" ||
      base64Input == "" ||
      base64Input.toLowerCase().contains("not found") ||
      base64Input.toLowerCase().contains("invalid")) {
    if (verbosityLevel >= vInfo) {
      print(
          "[V_INFO] Input is empty, error, or invalid. Returning placeholder.");
    }
    return FFUploadedFile(
        name: "placeholder_no_image.txt", bytes: Uint8List(0));
  }

  // Check if input looks like base64 (should contain base64 characters)
  final RegExp base64Pattern = RegExp(r'^[A-Za-z0-9+/]*={0,2}$');
  final String testString =
      base64Input.length > 100 ? base64Input.substring(0, 100) : base64Input;

  // Remove common prefixes for testing
  String testWithoutPrefix = testString;
  if (testString.contains(',')) {
    testWithoutPrefix = testString.substring(testString.indexOf(',') + 1);
  }

  // Check if the input contains at least some base64-like content
  if (!base64Pattern.hasMatch(
          testWithoutPrefix.replaceAll(RegExp(r'[^A-Za-z0-9+/=]'), '')) &&
      testWithoutPrefix.length < 20) {
    if (verbosityLevel >= vInfo) {
      print(
          "[V_INFO] Input does not appear to be valid base64 data. Input: $base64Input");
    }
    return FFUploadedFile(
        name: "placeholder_no_image.txt", bytes: Uint8List(0));
  }

  try {
    String base64Data = base64Input;
    if (verbosityLevel >= vDebug) {
      print(
        '[V_DEBUG] Initial base64Data (first 100): "${base64Data.substring(0, math.min(base64Data.length, 100))}${base64Data.length > 100 ? "..." : ""}"',
      );
    }

    final commaIndex = base64Data.indexOf(',');
    if (commaIndex != -1) {
      if (verbosityLevel >= vDebug) {
        print('[V_DEBUG] Data URI prefix found at index $commaIndex.');
      }
      base64Data = base64Data.substring(commaIndex + 1);
      if (verbosityLevel >= vDebug) {
        print(
          '[V_DEBUG] base64Data after prefix stripping (first 100): "${base64Data.substring(0, math.min(base64Data.length, 100))}${base64Data.length > 100 ? "..." : ""}"',
        );
      }
    } else {
      if (verbosityLevel >= vDebug) {
        print('[V_DEBUG] No Data URI prefix found.');
      }
    }

    if (logSpam) {
      print(
        '[V_SPAM] base64Data before filtering (length ${base64Data.length}): "$base64Data"',
      );
    }

    final RegExp base64CharsRegex = RegExp(r'[^A-Za-z0-9+/=]');
    String filteredBase64 = base64Data.replaceAll(base64CharsRegex, '');

    if (verbosityLevel >= vDebug) {
      print(
        '[V_DEBUG] base64Data after filtering non-Base64 chars (length ${filteredBase64.length}). Filtered (first 100): "${filteredBase64.substring(0, math.min(filteredBase64.length, 100))}${filteredBase64.length > 100 ? "..." : ""}"',
      );
    }
    if (logSpam && base64Data.length != filteredBase64.length) {
      String removedChars = "";
      for (int i = 0; i < base64Data.length; i++) {
        if (!RegExp(r'[A-Za-z0-9+/=]').hasMatch(base64Data[i])) {
          removedChars += base64Data[i];
        }
      }
      print('[V_SPAM] Characters removed by filter: "$removedChars"');
    }

    if (filteredBase64.isEmpty) {
      if (verbosityLevel >= vInfo) {
        print(
          "[V_INFO] Error: Base64 string is empty after filtering non-Base64 characters.",
        );
      }
      return FFUploadedFile(
        name: "error_empty_after_filter.txt",
        bytes: Uint8List(0),
      );
    }

    if (verbosityLevel >= vTrace) {
      print(
        '[V_TRACE] Attempting base64Decode on filtered string (length ${filteredBase64.length}).',
      );
    }
    Uint8List bytes = base64Decode(filteredBase64);
    if (verbosityLevel >= vInfo) {
      print('[V_INFO] Successfully decoded Base64 to ${bytes.length} bytes.');
    }
    if (logSpam && bytes.isNotEmpty) {
      print(
        '[V_SPAM] Decoded bytes (first 16, if any): ${bytes.take(16).map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );
    }

    return FFUploadedFile(name: fileName, bytes: bytes);
  } catch (e, stackTrace) {
    if (verbosityLevel >= vInfo) {
      print("[V_INFO] Error during Base64 processing: $e");
    }
    if (verbosityLevel >= vDebug) {
      print("[V_DEBUG] Stack trace for error: $stackTrace");
    }
    if (verbosityLevel >= vTrace) {
      print(
        "[V_TRACE] Original input that caused error (first 100): \"$originalInputForLog${base64Input.length > 100 ? "..." : ""}\"",
      );
    }
    return FFUploadedFile(
      name: "error_decode_failure.txt",
      bytes: Uint8List(0),
    );
  }
}
