import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:org_flutter/org_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../event.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime now = DateTime.now();

  OrgDocument orgDocument = OrgDocument(null, null);

  _CalendarPageState() {
    loadOrg();
  }

  Future<void> loadOrg() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file = File(result!.files.first.path.toString());
    String content = await file.readAsString();
    setState(() {
      orgDocument = OrgDocument.parse(content);
      // var events = parseOrg();
      // for (Event event in events) {
      //   eventsController.addEvent(
      //     CalendarEvent(
      //       dateTimeRange: DateTimeRange(
      //         start: event.date,
      //         end: event.date.add(const Duration(hours: 1)),
      //       ),
      //       data: event,
      //     ),
      //   );
      // }
    });
  }

  List<Event> parseOrg() {
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

  /// Add a [CalendarEvent] to the [EventsController].
  // void addEvents() {
  //   eventsController.addEvent(
  //     CalendarEvent(
  //       dateTimeRange: DateTimeRange(
  //         start: now,
  //         end: now.add(const Duration(hours: 1)),
  //       ),
  //       data: "Event 1",
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      child: SfCalendar(
        view: CalendarView.month,
        monthViewSettings: MonthViewSettings(showAgenda: true),
        dataSource: DataSource(parseOrg()),
      ),
    ),
  );
}

class DataSource extends CalendarDataSource {
  DataSource(List<Event> source) {
    appointments = source;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].date;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endDate;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }

  @override
  String? getNotes(int index) {
    // TODO: implement getNotes
    return "Hier können Notizen für den Termin stehen";
  }

  @override
  Color getColor(int index) {
    return Color.fromRGBO(100, 100, 100, 50);
  }
}
