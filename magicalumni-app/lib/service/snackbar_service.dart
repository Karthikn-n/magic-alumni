import 'package:flutter/material.dart';
import 'package:magic_alumni/app/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomSnackbarService{
 static final _snackbarService = locator<SnackbarService>();

 static void registerSnackbarService() {
  _snackbarService.registerSnackbarConfig(
    SnackbarConfig(
      borderRadius: 12,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      forwardAnimationCurve: Curves.linear,
      reverseAnimationCurve: Curves.linear,
      snackPosition: SnackPosition.BOTTOM
    )
  );
 }

}