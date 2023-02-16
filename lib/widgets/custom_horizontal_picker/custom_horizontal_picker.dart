import 'package:flutter/material.dart';
import 'custom_item_widget.dart';

enum InitialPosition { start, center, end }

class HorizontalPicker extends StatefulWidget {
  late double minValue, maxValue;
  late int divisions;
  final double height;
  final Function(String) onChanged;
  final InitialPosition initialPosition;
  final Color backgroundColor;
  final bool showCursor;
  final Color cursorColor;
  final Color activeItemTextColor;
  final Color passiveItemsTextColor;
  final String suffix,
      prefix,
      subLeftSuffix,
      subRightSuffix,
      subLeftPrefix,
      subRightPrefix;

  final List mainData, subDataLeft, subDataRight, sizePrice;

  HorizontalPicker({
    super.key,
    this.minValue = 0.0,
    this.maxValue = 0.0,
    this.divisions = 0,
    required this.height,
    required this.onChanged,
    this.initialPosition = InitialPosition.center,
    this.backgroundColor = Colors.white,
    this.showCursor = true,
    this.cursorColor = Colors.red,
    this.activeItemTextColor = Colors.blue,
    this.passiveItemsTextColor = Colors.grey,
    this.suffix = "",
    this.prefix = "",
    required this.mainData,
    required this.subDataLeft,
    required this.subDataRight,
    required this.sizePrice,
    this.subLeftPrefix = "",
    this.subLeftSuffix = "",
    this.subRightPrefix = "",
    this.subRightSuffix = "",
  });

  @override
  // ignore: library_private_types_in_public_api
  _HorizontalPickerState createState() => _HorizontalPickerState();
}

class _HorizontalPickerState extends State<HorizontalPicker> {
  late FixedExtentScrollController _scrollController;
  late int curItem;
  List<Map> valueMap = [];

  @override
  void initState() {
    super.initState();

    // for (var i = 0; i <= widget.divisions; i++) {
    //   valueMap.add({
    //     "value": widget.minValue +
    //         ((widget.maxValue - widget.minValue) / widget.divisions) * i,
    //     "fontSize": 14.0,
    //     "color": widget.passiveItemsTextColor,
    //   });
    // }
    for (var element in widget.mainData) {
      valueMap.add({
        "value": element,
        "fontSize": 13.0,
        "color": widget.passiveItemsTextColor,
      });
    }
    setScrollController();
  }

  void setScrollController() {
    int initialItem;
    switch (widget.initialPosition) {
      case InitialPosition.start:
        initialItem = 0;
        break;
      case InitialPosition.center:
        initialItem = (valueMap.length ~/ 2);
        break;
      case InitialPosition.end:
        initialItem = valueMap.length - 1;
        break;
    }

    _scrollController = FixedExtentScrollController(initialItem: initialItem);
    valueMap[initialItem]["color"] = widget.activeItemTextColor;
    valueMap[initialItem]["fontSize"] = 16.0;
    valueMap[initialItem]["fontWeight"] = FontWeight.w900;
    valueMap[initialItem]["hasBorders"] = true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0),
      height: widget.height,
      alignment: Alignment.center,
      color: widget.backgroundColor,
      child: RotatedBox(
        quarterTurns: 3,
        child: ListWheelScrollView(
            controller: _scrollController,
            physics: const FixedExtentScrollPhysics(),
            itemExtent: 60,
            // itemExtent:MediaQuery.of(context).size.width * 0.15,
            perspective: 0.000000000001,
            onSelectedItemChanged: (item) {
              curItem = item;
              // int decimalCount = 1;
              // num fac = pow(10, decimalCount);
              // valueMap[item]["value"] =
              //     (valueMap[item]["value"] * fac).round() / fac;
              widget.onChanged(valueMap[item]["value"].toString());
              for (var i = 0; i < valueMap.length; i++) {
                if (i == item) {
                  valueMap[item]["color"] = widget.activeItemTextColor;
                  valueMap[item]["fontSize"] = 16.0;
                  valueMap[item]["fontWeight"] = FontWeight.w900;
                  valueMap[item]["hasBorders"] = true;
                } else {
                  valueMap[i]["color"] = widget.passiveItemsTextColor;
                  valueMap[i]["fontSize"] = 14.0;
                  valueMap[i]["fontWeight"] = FontWeight.normal;
                  valueMap[i]["hasBorders"] = false;
                }
              }
              setState(() {});
            },
            children: valueMap.map((Map curValue) {
              int index = valueMap.indexOf(curValue);
              return ItemWidget(
                curValue,
                widget.backgroundColor,
                widget.suffix,
                widget.prefix,
                widget.subDataLeft[index].toString(),
                widget.subDataRight[index].toString(),
                widget.subLeftPrefix,
                widget.subRightPrefix,
                widget.subLeftSuffix,
                widget.subRightSuffix,
                widget.sizePrice[index],
              );
            }).toList()),
      ),
      // Visibility(
      //   visible: widget.showCursor,
      //   child: Container(
      //     alignment: Alignment.center,
      //     padding: const EdgeInsets.all(5),
      //     child: Container(
      //       decoration: BoxDecoration(
      //         borderRadius: const BorderRadius.all(
      //           Radius.circular(10),
      //         ),
      //         color: widget.cursorColor.withOpacity(0.3),
      //       ),
      //       width: 3,
      //     ),
      //   ),
      // )
    );
  }
}
