// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class CustomRow extends StatefulWidget {
  CustomRow({
    super.key,
    required this.width,
    required this.backgroundColor,
    required this.iconData,
    required this.customWidget,
  });

  final double width;
  final Color backgroundColor;
  final IconData iconData;
  final Widget customWidget;

  @override
  State<CustomRow> createState() => _CustomRowState();
}

class _CustomRowState extends State<CustomRow> {
  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: widget.width / 8,
          width: widget.width / 8,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Icon(widget.iconData),
        ),
        SizedBox(
          width: widget.width / 20,
        ),
        SizedBox(
          height: widget.width / 6,
          child: VerticalDivider(
            color: Colors.grey.withOpacity(0.5),
            thickness: 1.7,
          ),
        ),
        SizedBox(
          width: widget.width / 20,
        ),
        Flexible(
          child: widget.customWidget,
        ),
      ],
    );
  }
}