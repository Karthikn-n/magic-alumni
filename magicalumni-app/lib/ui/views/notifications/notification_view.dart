import 'package:flutter/material.dart';

class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading:  BackButton(
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(
          "Notifications", 
          style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
        ) ,
        centerTitle: true,
      ),
    );
  }
}