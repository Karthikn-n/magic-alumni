import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String buttonName;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final double? width;
  const FilterButton({
    super.key, 
    required this.buttonName, 
    required this.onPressed,
    this.width,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(8),
      onTap: onPressed,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: backgroundColor != null ? Colors.transparent : Theme.of(context).primaryColor
          )
        ),
        child: Center(
          child: Text(
            buttonName,
            style: TextStyle(
              fontSize: 12,
              color: backgroundColor != null ? Colors.white: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
    // ElevatedButton(
    //   onPressed: onPressed, 
    //   style: ElevatedButton.styleFrom(
    //     padding: EdgeInsets.all(0),
    //     elevation: 0,
    //     backgroundColor: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
    //     shape: RoundedRectangleBorder(
    //       side: BorderSide(color: )
    //     )
    //   ),
    //   child: 
    // );
  }
}