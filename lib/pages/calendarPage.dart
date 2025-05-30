import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:org_parser/org_parser.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../event_data_source.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarController calendarController = CalendarController();

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
    });
  }

  void calendarLongPress(CalendarLongPressDetails calendarLongPress) {
    if (calendarController.view == CalendarView.month) {
      setState(() {
        calendarController.displayDate = calendarLongPress.date;
        calendarController.view = CalendarView.day;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: CalendarView.week,
        allowedViews: [
          CalendarView.month,
          CalendarView.week,
          CalendarView.day,
          CalendarView.schedule,
        ],
        timeSlotViewSettings: TimeSlotViewSettings(timeFormat: "H:mm"),
        controller: calendarController,
        monthViewSettings: MonthViewSettings(
          showAgenda: true,
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
        onLongPress: calendarLongPress,
        dataSource: getEventDataSource(orgDocument),
      ),
    );
  }
}
