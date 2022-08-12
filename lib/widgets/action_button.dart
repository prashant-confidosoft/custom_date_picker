import 'package:flutter/material.dart';

class BottomBarActionButton extends StatelessWidget {
  const BottomBarActionButton({
    Key? key,
    required this.onSubmit,
    required this.onCancel,
    this.title = '',
    this.buttonTextStyle,
    this.titleTextStyle,
    this.cancelButtonTitle ,
    this.doneButtonTitle ,
  }) : super(key: key);

  final String title;
  final String? cancelButtonTitle;
  final String? doneButtonTitle;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final TextStyle? buttonTextStyle;
  final TextStyle? titleTextStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onCancel,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              
              child: Text(
                cancelButtonTitle ?? 'Cancel',
                style: buttonTextStyle,
              ),
            ),
          ),
          Text(title, style: titleTextStyle ?? const TextStyle(fontSize: 20)),
          InkWell(
            onTap: onSubmit,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                doneButtonTitle ?? 'Done',
                style: buttonTextStyle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
