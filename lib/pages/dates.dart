import 'package:flutter/material.dart';

Widget datePage(String display, BuildContext context) => Center(
  child: SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(display, style: Theme.of(context).textTheme.headlineMedium),
      ],
    ),
  ),
);
