import 'package:custom_date_picker/resources/values.dart';
import 'package:custom_date_picker/widgets/action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class MonthAndYearPicker extends StatefulWidget {
  const MonthAndYearPicker({
    Key? key,
    required this.initialDateTime,
    required this.maxDateTime,
    required this.minDateTime,
    required this.onDateSubmit,
    this.monthFormat,
    this.dismissable = false,
    this.titleStyle = const TextStyle(),
    this.buttonTextStyle = const TextStyle(),
    this.pickerTextStyle = const TextStyle(
      fontSize: 14,
      color: Colors.black,
    ),
    this.title = '',
    this.backgroundColor = Colors.white,
    this.cancelButtonTitle,
    this.doneButtonTitle,
  }) : super(key: key);

  final Function(DateTime) onDateSubmit;
  final DateTime initialDateTime;
  final DateTime maxDateTime;
  final DateTime minDateTime;
  final String? monthFormat;
  final bool dismissable;
  final TextStyle pickerTextStyle;
  final TextStyle titleStyle;
  final TextStyle buttonTextStyle;
  final String title;
  final Color backgroundColor;
  final String? cancelButtonTitle;
  final String? doneButtonTitle;

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
  State<MonthAndYearPicker> createState() => _MonthAndYearPickerState();
}

class _MonthAndYearPickerState extends State<MonthAndYearPicker> {
  var selectedMonth = 0;
  var selectedYear = 0;
  var itemExtent = 30.0;
  BehaviorSubject<List<String>> arrMonth = BehaviorSubject<List<String>>();
  var controller = FixedExtentScrollController();
  var isChangeYear = false;

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialDateTime.month;
    selectedYear = widget.initialDateTime.year;
    getData();
  }

  void getData() async {
    arrMonth.add(await getArrayMonth(selectedYear));

    controller = FixedExtentScrollController(
        initialItem: arrMonth.value.indexOf(selectedMonth.toString()));
    setState(() {});
  }

  Future<List<String>> getArrayMonth(int selectedYear) async {
    if (selectedYear == widget.minDateTime.year) {
      var totalMonth = (12 - widget.minDateTime.month) + 1;
      return List.generate((totalMonth), (index) {
        if (index == 0) {
          return '${widget.minDateTime.month}';
        } else {
          return '${widget.minDateTime.month + index}';
        }
      });
    } else if (selectedYear == widget.maxDateTime.year) {
      return List.generate((widget.maxDateTime.month),
          (index) => DateTime(selectedYear, index + 1).month.toString());
    } else {
      return List.generate(
          12, (index) => DateTime(selectedYear, index + 1).month.toString());
    }
  }

  Future<List<String>> getArrayYear() async {
    var totalNumberOfYears = widget.maxDateTime.year - widget.minDateTime.year;
    return List.generate(totalNumberOfYears + 1, (index) {
      if (index == 0) {
        return widget.minDateTime.year.toString();
      } else {
        return (widget.minDateTime.year + index).toString();
      }
    });
  }

  String getMonths(String month) {
    final DateFormat formatter = DateFormat(widget.monthFormat ?? 'MMM');
    final String formatted =
        formatter.format(DateTime(2000, int.parse(month), 1));
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    var widthPicker = (MediaQuery.of(context).size.width - (padding * 2)) / 2;
    return CupertinoTheme(
      data: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: widget.pickerTextStyle,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: borderRadius,
        ),
        height: height,
        child: Padding(
          padding: const EdgeInsets.all(padding),
          child: Column(
            children: [
              BottomBarActionButton(
                title: widget.title,
                cancelButtonTitle: widget.cancelButtonTitle,
                doneButtonTitle: widget.doneButtonTitle,
                titleTextStyle: widget.titleStyle,
                onCancel: () {
                  Navigator.pop(context);
                },
                onSubmit: () {
                  Navigator.pop(context);
                  widget.onDateSubmit(DateTime(selectedYear, selectedMonth));
                },
              ),
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: widthPicker,
                      child: arrMonth.valueOrNull == null
                          ? Container()
                          : CupertinoPicker.builder(
                              backgroundColor: Colors.white,
                              itemExtent: itemExtent,
                              scrollController: controller,
                              onSelectedItemChanged: (index) {
                                if (!isChangeYear) {
                                  selectedMonth =
                                      int.parse(arrMonth.value[index]);
                                  // print(
                                  //     'Month Selection Call $selectedMonth ${getMonths(arrMonth.value[index])}');
                                } else {
                                  isChangeYear = false;
                                }
                              },
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Text(
                                    getMonths(arrMonth.value[index]),
                                    style: widget.pickerTextStyle,
                                  ),
                                );
                              },
                              childCount: arrMonth.value.length),
                    ),
                    SizedBox(
                      width: widthPicker,
                      child: FutureBuilder<List<String>>(
                          future: getArrayYear(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return CupertinoPicker(
                                backgroundColor: Colors.white,
                                itemExtent: itemExtent,
                                scrollController: FixedExtentScrollController(
                                    initialItem: snapshot.data?.indexOf(
                                            selectedYear.toString()) ??
                                        0),
                                children: List.generate(
                                    (snapshot.data ?? <String>[]).length,
                                    (index) => Center(
                                          child: Text(
                                            snapshot.data?[index] ?? '',
                                            style: widget.pickerTextStyle,
                                          ),
                                        )),
                                onSelectedItemChanged: (value) async {
                                  selectedYear =
                                      int.parse(snapshot.data?[value] ?? '');
                                  isChangeYear = true;
                                  var arrayOfMonth =
                                      await getArrayMonth(selectedYear);
                                  // ignore: iterable_contains_unrelated_type
                                  var data = arrayOfMonth
                                      .where((element) =>
                                          element == selectedMonth.toString())
                                      .toList();
                                  if (data.isEmpty) {
                                    if (selectedYear ==
                                        widget.minDateTime.year) {
                                      selectedMonth = widget.minDateTime.month;
                                    } else if (selectedYear ==
                                        widget.maxDateTime.year) {
                                      selectedMonth = widget.maxDateTime.month;
                                    }
                                  } else {
                                    // selectedMonth = int.parse(data[0]);
                                  }
                                  var index = arrayOfMonth
                                      .indexOf(selectedMonth.toString());
                                  arrMonth.add(arrayOfMonth);
                                  if (index == -1) {
                                    controller.jumpToItem(0);
                                  } else {
                                    controller.jumpToItem(index);
                                    // if (index == controller.selectedItem) {
                                    //   controller.jumpToItem(index);
                                    // } else {
                                    //   controller.jumpToItem(controller.selectedItem);
                                    // }
                                  }
                                  setState(() {});
                                },
                              );
                            } else {
                              return Container();
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
