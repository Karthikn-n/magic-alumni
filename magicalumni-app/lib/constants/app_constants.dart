import 'package:flutter/material.dart';

const double commonPadding = 16.0;

ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: Colors.white,
  disabledBackgroundColor: Colors.grey,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(0),
  ),
);

TextStyle textStyle = const TextStyle(
  fontSize: 14,
  color: Colors.white,
);

const String baseApiUrl = "http://localhost-5000/api/";
