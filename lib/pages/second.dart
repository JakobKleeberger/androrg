import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget secondPage(String display, BuildContext context) => Center(
  child: SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Zweite Page', style: Theme.of(context).textTheme.headlineMedium),
      ],
    ),
  ),
);
