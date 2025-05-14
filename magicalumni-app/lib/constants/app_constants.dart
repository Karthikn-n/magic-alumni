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

const String baseApiUrl = "http://192.168.1.14:3000/api/";
const String whatappAPIUrl = "http://api.whatsappmessages.in/wapp/api/send?apikey=f24080a2043a46248237a06e30b4c7b2&mobile=";

const TextStyle appBarTextStyle = TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600);