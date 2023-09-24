import 'package:alarm_app/config.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String initialValue;
  final Function onChanged;
  final double? minHeight;

  const CustomTextField({
    super.key,
    required this.initialValue,
    required this.onChanged,
    this.minHeight,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(minHeight: widget.minHeight ?? 40),
          width: width * 0.9,
          child: TextFormField(
            initialValue: widget.initialValue,
            maxLines: 4,
            cursorColor: Config.orange,
            style: const TextStyle(
              fontSize: Config.textFontSize,
            ),
            decoration: InputDecoration(
              fillColor: Config.white,
              // border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Config.orange),
                borderRadius: BorderRadius.circular(10),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: (value) {
              widget.onChanged(value);
            },
          ),
        ),
      ],
    );
  }
}
