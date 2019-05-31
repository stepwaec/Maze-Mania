import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class RuleImport {

  Future<String> readRules() async {
    try {
      // Read the file
      String contents = await rootBundle.loadString('assets/rules.json');

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return '';
    }
  }
}