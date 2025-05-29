import 'dart:collection';

import 'package:org_flutter/org_flutter.dart';

class Event {
  String title = "";
  late DateTime date;
  late HashMap<OrgSimpleTimestamp, int> timestampsInEvent;

  getDate(OrgNode timestamp) {
    switch (timestamp.runtimeType) {
      case OrgSimpleTimestamp:
        OrgSimpleTimestamp simpleTimestamp = timestamp as OrgSimpleTimestamp;

        OrgDate orgDate = simpleTimestamp.date;
        OrgTime? orgTime = simpleTimestamp.time;
        if (orgTime != null) {
          date = DateTime(
              int.parse(orgDate.year), int.parse(orgDate.month), int.parse(orgDate.day),
              int.parse(orgTime.hour), int.parse(orgTime.minute));
        } else {
          date = DateTime(
              int.parse(orgDate.year), int.parse(orgDate.month), int.parse(orgDate.day));
        }
    // case OrgDateRangeTimestamp:
    // // TODO: Handle this case.
    //   throw UnimplementedError();
    // case OrgTimeRangeTimestamp
    // // TODO: Handle this case.
    //   throw UnimplementedError();
    }
  }
}