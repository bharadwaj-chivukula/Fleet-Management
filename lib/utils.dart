import 'dart:async';

import 'package:flutter/material.dart';

String toyyyyMMdd(DateTime date) {
  String result = date.year.toString() +
      "-" +
      date.month.toString() +
      "-" +
      date.day.toString();
  return result;
}

Future<Null> userDialog(
    BuildContext context, String messagetext, String actiontext) async {
  return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => new AlertDialog(
            title: new Text('Message'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(messagetext != null ? messagetext : ""),
                  //new Text('You\’re like me. I’m never satisfied.'),
                ],
              ),
            ),
            actions: <Widget>[
              new TextButton(
                child: new Text(actiontext),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ));
}
