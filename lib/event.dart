import 'dart:ui';

import 'package:my_app/tag_colors.dart';
import 'package:org_parser/org_parser.dart';

class Event {
  String title = "";
  DateTime? startDate;
  DateTime? endDate;
  bool isAllDay = true;
  List<String>? tags;
  Color color = Color.fromRGBO(100, 100, 100, 50);

  getDate(OrgNode timestamp) {
    switch (timestamp.runtimeType) {
      case OrgSimpleTimestamp:
        OrgSimpleTimestamp simpleTimestamp = timestamp as OrgSimpleTimestamp;

        OrgTime? orgTime = simpleTimestamp.time;
        startDate = simpleTimestamp.dateTime;
        if (orgTime != null) isAllDay = false;
        endDate = startDate?.add(Duration(hours: 1));
        break;
      case OrgDateRangeTimestamp:
        OrgDateRangeTimestamp dateRangeTimestamp =
            timestamp as OrgDateRangeTimestamp;
        startDate = dateRangeTimestamp.start.dateTime;
        if (dateRangeTimestamp.start.time != null) isAllDay = false;
        endDate = dateRangeTimestamp.end.dateTime;
        if (dateRangeTimestamp.end.time != null) isAllDay = false;
        break;
      case OrgTimeRangeTimestamp:
        OrgTimeRangeTimestamp timeRangeTimestamp =
            timestamp as OrgTimeRangeTimestamp;
        startDate = timeRangeTimestamp.startDateTime;
        endDate = timeRangeTimestamp.endDateTime;
        isAllDay = false;
        break;
    }
  }

  setTags(List<String> tags) {
    this.tags = tags;
    if (tags.isNotEmpty) {
      var colors = TagColors();
      color = colors.getColor(tags.first)!;
    }
  }
}
