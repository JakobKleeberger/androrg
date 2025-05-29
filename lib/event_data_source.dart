import 'dart:ui';

import 'package:my_app/event.dart';
import 'package:org_parser/org_parser.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startDate;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endDate;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }

  @override
  String? getNotes(int index) {
    return "Hier können Notizen für den Termin stehen";
  }

  @override
  Color getColor(int index) {
    return appointments![index].color;
  }
}

EventDataSource getEventDataSource(OrgDocument orgDocument) {
  List<Event> events = _parseOrg(orgDocument);
  for (Event event in events) {
  }
  return EventDataSource(events);
}

List<Event> _parseOrg(OrgDocument orgDocument) {
  List<Event> events = [];
  late Event event;

  orgDocument.visitSections((node) {
    String title = "";
    OrgHeadline headline = node.headline;
    OrgContent? headlineTitle = headline.title;
    if (headlineTitle != null) {
      var headlineParts = headlineTitle.children;
      for (OrgNode part in headlineParts) {
        if (part is OrgPlainText) {
          title = title + part.content;
        }
      }
    }

    event = Event();
    event.title = title;
    event.setTags(node.tags);

    //dates
    List<int> visitedSectionNodes = [];
    node.visit<OrgNode>((node) {
      int hash = node.hashCode;
      if (visitedSectionNodes.contains(hash)) return true;
      visitedSectionNodes.add(hash);
      if (node is OrgTimeRangeTimestamp || node is OrgSimpleTimestamp) {
        event.getDate(node);
      } else if (node is OrgDateRangeTimestamp) {
        event.getDate(node);
        visitedSectionNodes.add(node.start.hashCode);
        visitedSectionNodes.add(node.end.hashCode);
      }
      return true;
    });

    events.add(event);
    return true;
  });
  return events;
}
