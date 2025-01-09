import 'package:flutter/material.dart';


/// Across the app this gives loading indication to the User on waiting time from the Server
class LoadingButtonWidget extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? ciricularColor;
  final Color? buttonColor;
  const LoadingButtonWidget({
    super.key, 
    this.height, 
    this.width,
    this.ciricularColor,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? Theme.of(context).primaryColor,
        ),
        onPressed: (){}, 
        child: Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: ciricularColor ?? Colors.white,
              strokeCap: StrokeCap.round,
            ),
          ),
        )
      ),
    );
  }
}