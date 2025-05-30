import 'dart:collection';

import 'package:flutter/material.dart';

class TagColors {
  late Map<String, Color> tagColors = HashMap();

  TagColors() {
    tagColors.addAll({"school": Colors.blue});
    tagColors.addAll({"tollestag": Colors.green});
  }

  Color? getColor(String tag) {
    return tagColors[tag];
  }
}
