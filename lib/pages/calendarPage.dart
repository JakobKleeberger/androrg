import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'package:org_flutter/org_flutter.dart';

import '../event.dart';

class CalendarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final eventsController = DefaultEventsController();
  final calendarController = CalendarController();
  DateTime now = DateTime.now();

  late OrgDocument orgDocument;

  _CalendarPageState() {
    loadOrg();
  }

  Future<void> loadOrg() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file = File(result!.files.first.path.toString());
    String content = await file.readAsString();
    setState(() {
      orgDocument = OrgDocument.parse(content);
      var events = parseOrg();
      for (Event event in events) {
        eventsController.addEvent(
          CalendarEvent(
            dateTimeRange: DateTimeRange(
              start: event.date,
              end: event.date.add(const Duration(hours: 1)),
            ),
            data: event,
          ),
        );
      }
    });
  }

  List<Event> parseOrg() {
    List<int> visitedNodes = [];
    String title = "";
    List<Event> events = [];
    late Event event;

    orgDocument.visitSections((node) {
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
  void addEvents() {
    eventsController.addEvent(
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: now,
          end: now.add(const Duration(hours: 1)),
        ),
        data: "Event 1",
      ),
    );
  }

  @override
  Widget build(BuildContext context) => CalendarView(
    eventsController: eventsController,
    calendarController: calendarController,
    // The calender widget will automatically display the correct header & body widgets based on the viewConfiguration.
    viewConfiguration: MonthViewConfiguration.singleMonth(),
    callbacks: CalendarCallbacks(
      onEventTapped:
          (event, renderBox) => calendarController.selectEvent(event),
      onEventCreate: (event) => event.copyWith(data: "Some data"),
      onEventCreated: (event) => eventsController.addEvent(event),
    ),
    header: CalendarHeader(multiDayTileComponents: null),
    body: CalendarBody(),
  );
}
