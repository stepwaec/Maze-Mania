import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class JSONManager {

  Future<String> readJSON(path) async {
    try {
      // Read the file
      String contents = await rootBundle.loadString(path);

      return contents;
    } catch (e) {
      return 'ERROR: '+path;
    }
  }
}