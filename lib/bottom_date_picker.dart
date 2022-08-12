import 'package:custom_date_picker/resources/values.dart';
import 'package:custom_date_picker/widgets/action_button.dart';
import 'package:custom_date_picker/widgets/date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:custom_date_picker/resources/extensions.dart';

// ignore: must_be_immutable
class CSBottomDateTimePicker extends StatefulWidget {
  CSBottomDateTimePicker.date({
    Key? key,
    required this.title,
    this.titleStyle = const TextStyle(),
    this.dismissable = false,
    required this.onDateSubmit,
    this.gradientColors,
    this.iconColor = Colors.white,
    this.initialDateTime,
    this.minDateTime,
    this.maxDateTime,
    this.backgroundColor = Colors.white,
    this.dateOrder = DatePickerDateOrder.ymd,
    this.cancelButtonTitle,
    this.doneButtonTitle,
    this.pickerTextStyle = const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
  }) : super(key: key) {
    datePickerMode = CupertinoDatePickerMode.date;
    use24hFormat = false;
    itemExtent = 0;
    assertInitialValues();
  }

  CSBottomDateTimePicker.dateTime({
    Key? key,
    required this.title,
    this.titleStyle = const TextStyle(),
    this.dismissable = false,
    required this.onDateSubmit,
    this.gradientColors,
    this.iconColor = Colors.white,
    this.initialDateTime,
    this.minuteInterval,
    this.minDateTime,
    this.maxDateTime,
    this.use24hFormat = false,
    this.backgroundColor = Colors.white,
    this.dateOrder = DatePickerDateOrder.ymd,
    this.cancelButtonTitle,
    this.doneButtonTitle,
    this.pickerTextStyle = const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
  }) : super(key: key) {
    datePickerMode = CupertinoDatePickerMode.dateAndTime;
    itemExtent = 0;
    assertInitialValues();
  }

  CSBottomDateTimePicker.time({
    Key? key,
    required this.title,
    this.titleStyle = const TextStyle(),
    this.dismissable = false,
    required this.onDateSubmit,
    this.gradientColors,
    this.iconColor = Colors.white,
    this.initialDateTime,
    this.minDateTime,
    this.maxDateTime,
    this.use24hFormat = false,
    this.backgroundColor = Colors.white,
    this.cancelButtonTitle,
    this.doneButtonTitle,
    this.pickerTextStyle = const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
  }) : super(key: key) {
    datePickerMode = CupertinoDatePickerMode.time;
    dateOrder = null;
    itemExtent = 0;
    assertInitialValues();
  }

  final String title;
  final TextStyle titleStyle;
  final bool dismissable;
  final Function(DateTime) onDateSubmit;
  final List<Color>? gradientColors;
  final Color iconColor;
  late int selectedItemIndex;
  DateTime? initialDateTime;
  int? minuteInterval;
  DateTime? maxDateTime;
  DateTime? minDateTime;
  late bool use24hFormat;
  final Color backgroundColor;
  late DatePickerDateOrder? dateOrder;
  final TextStyle pickerTextStyle;
  late double itemExtent;
  final String? cancelButtonTitle;
  final String? doneButtonTitle;
    ///The dateTime picker mode
  ///[CupertinoDatePickerMode.date] or [CupertinoDatePickerMode.dateAndTime] or [CupertinoDatePickerMode.time]
  ///
  late CupertinoDatePickerMode datePickerMode;

  void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: dismissable,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomSheet(
          backgroundColor: Colors.transparent,
          enableDrag: false,
          onClosing: () {},
          builder: (context) {
            return this;
          },
        );
      },
    );
  }

  @override
  // ignore: library_private_types_in_public_api
  _CSBottomDateTimePickerState createState() => _CSBottomDateTimePickerState();
}

class _CSBottomDateTimePickerState extends State<CSBottomDateTimePicker> {
  late int selectedItemIndex;
  late DateTime selectedDateTime;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDateTime ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(padding),
        child: Column(
          children: [
            BottomBarActionButton(
              title: widget.title,
              titleTextStyle: widget.titleStyle,
              onCancel: () {
                Navigator.pop(context);
              },
              onSubmit: () {
                widget.onDateSubmit(selectedDateTime);
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: DatePicker(
                initialDateTime: widget.initialDateTime,
                minuteInterval: widget.minuteInterval ?? 1,
                maxDateTime: widget.maxDateTime,
                minDateTime: widget.minDateTime,
                mode: widget.datePickerMode,
                onDateChanged: (DateTime date) {
                  debugPrint('onDateChanged: $date');
                  selectedDateTime = date;
                },
                use24hFormat: widget.use24hFormat,
                dateOrder: widget.dateOrder,
                textStyle: widget.pickerTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
