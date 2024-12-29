import 'package:flutter/material.dart';
import 'package:rizzhub/components/constants.dart';

class CustomTextfield extends StatefulWidget {
  const CustomTextfield(
      {super.key,
      this.readOnly = false,
      this.focusNode,
      this.controller,
      required this.maxLines,
      this.hintText,
      required this.label});
  final FocusNode? focusNode;
  final bool readOnly;
  final int maxLines;
  final String? hintText;
  final String label;
  final TextEditingController? controller;

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: widget.readOnly,
      cursorColor: Constants.primaryColor,
      maxLines: widget.maxLines,
      focusNode: widget.focusNode,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintText: widget.hintText,
        label: Text(
          widget.label,
          style: TextStyle(
            color: Constants.primaryColor,
            fontFamily: "Poppins",
          ),
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: "Poppins",
      ),
    );
  }
}
