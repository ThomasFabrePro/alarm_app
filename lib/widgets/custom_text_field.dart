import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String initialValue;
  final Function onChanged;
  final double? minHeight;
  final double fontSize;
  const CustomTextField(
      {super.key,
      required this.initialValue,
      required this.onChanged,
      this.minHeight,
      required this.fontSize});

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
            maxLines: 6,
            style: TextStyle(
              fontSize: widget.fontSize,
            ),
            decoration: InputDecoration(
              fillColor: Colors.white,
              // border: InputBorder.none,
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
