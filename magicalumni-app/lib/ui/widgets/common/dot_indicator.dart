
import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
    this.inActiveColor,
    this.activeColor,
  });

  final bool isActive;

  final Color? inActiveColor, activeColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:  6,
      width: isActive ? 16 : 6,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).primaryColor
            : Color(0xFFF7CA18),
        borderRadius: const BorderRadius.all(Radius.circular(30.0)),
      ),
    );
  }
}
