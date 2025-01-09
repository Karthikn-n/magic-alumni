import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLength;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? readOnly;
  final String? counterText;
  final TextInputAction? textInputAction;
  final VoidCallback? onTap;
  final Function(String value)? onChanged;
  const TextFieldWidget({
    super.key,
    this.keyboardType,
    this.controller,
    this.hintText,
    this.maxLength,
    this.maxLines,
    this.prefixIcon,
    this.readOnly,
    this.suffixIcon,
    this.onChanged,
    this.counterText = "",
    this.textInputAction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400
        ),
        readOnly: readOnly ?? false,
        controller: controller,
        maxLength: maxLength,
        maxLines: maxLines,
        textInputAction: textInputAction,
        keyboardType:  keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          counterText: counterText,
          hintStyle: TextStyle(
            fontSize: 12,
            color: Colors.black45
          ),
          hintText: hintText,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}