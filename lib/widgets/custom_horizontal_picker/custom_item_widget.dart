// import 'dart:math';

// import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatefulWidget {
  final Map curItem;
  final Color backgroundColor;
  final String suffix;
  final String prefix;
  final String subDataLeft;
  final String subDataRight;
  final String subLeftPrefix;
  final String subRightPrefix;
  final String subLeftSuffix;
  final String subRightSuffix;
  final String sizePrice;

  const ItemWidget(
    this.curItem,
    this.backgroundColor,
    this.suffix,
    this.prefix,
    this.subDataLeft,
    this.subDataRight,
    this.subLeftPrefix,
    this.subRightPrefix,
    this.subLeftSuffix,
    this.subRightSuffix,
    this.sizePrice, {
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  // late List<String> textParts;
  // late String leftText, rightText;
  late String mainText;

  @override
  void initState() {
    super.initState();
    // int decimalCount = 1;
    // num fac = pow(10, decimalCount);

    // var mtext = ((widget.curItem["value"] * fac).round() / fac).toString();
    // textParts = mtext.split(".");
    // leftText = textParts.first;
    // rightText = textParts.last;
    mainText = widget.curItem["value"].toString();
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Text(
          //   "|",
          //   style: TextStyle(fontSize: 8.5, color: widget.curItem["color"]),
          // ),
          // SizedBox(
          //   // width: 60,
          //   height: 10,
          const SizedBox(
            height: 3,
          ),
          RichText(
            softWrap: false,
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.subLeftPrefix.isEmpty
                      ? ""
                      : '${widget.subLeftPrefix} ',
                  style: TextStyle(
                    fontSize: widget.curItem["fontSize"] - 8.5,
                    fontWeight: widget.curItem['fontWeight'],
                    color: widget.curItem["color"],
                  ),
                ),
                TextSpan(
                  text: widget.subDataLeft.toString(),
                  style: TextStyle(
                      fontSize: widget.curItem["fontSize"] - 8.5,
                      color: widget.curItem["color"],
                      fontWeight: widget.curItem['fontWeight']),
                ),
                TextSpan(
                  text: widget.subLeftSuffix.isEmpty
                      ? ""
                      : ' ${widget.subLeftSuffix}',
                  style: TextStyle(
                    fontSize: widget.curItem["fontSize"] - 8.5,
                    color: widget.curItem["color"],
                    fontWeight: widget.curItem['fontWeight'],
                  ),
                ),
                TextSpan(
                  text: " / ",
                  style: TextStyle(
                    fontSize: widget.curItem["fontSize"] - 8.5,
                    color: widget.curItem["color"],
                    fontWeight: widget.curItem['fontWeight'],
                  ),
                ),
                TextSpan(
                  text: widget.subRightPrefix.isEmpty
                      ? ""
                      : '${widget.subRightPrefix} ',
                  style: TextStyle(
                    fontSize: widget.curItem["fontSize"] - 8.5,
                    fontWeight: widget.curItem['fontWeight'],
                    color: widget.curItem["color"],
                  ),
                ),
                TextSpan(
                  text: widget.subDataRight.toString(),
                  style: TextStyle(
                    fontSize: widget.curItem["fontSize"] - 8.5,
                    color: widget.curItem["color"],
                    fontWeight: widget.curItem['fontWeight'],
                  ),
                ),
                TextSpan(
                  text: widget.subRightSuffix.isEmpty
                      ? ""
                      : ' ${widget.subRightSuffix}',
                  style: TextStyle(
                    fontSize: widget.curItem["fontSize"] - 8.5,
                    color: widget.curItem["color"],
                    fontWeight: widget.curItem['fontWeight'],
                  ),
                )
              ],
            ),
          ),
          // ),
          const SizedBox(
            height: 2,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.prefix.isEmpty ? "" : widget.prefix,
                  style: TextStyle(
                    fontSize: widget.curItem["fontSize"],
                    fontWeight: widget.curItem['fontWeight'],
                    color: widget.curItem["color"],
                  ),
                ),
                TextSpan(
                  text: mainText,
                  style: TextStyle(
                    fontSize: widget.curItem["fontSize"],
                    color: widget.curItem["color"],
                    fontWeight: widget.curItem['fontWeight'],
                  ),
                ),
                TextSpan(
                  text: widget.suffix.isEmpty ? "" : widget.suffix,
                  style: TextStyle(
                    fontSize: widget.curItem["fontSize"],
                    color: widget.curItem["color"],
                    fontWeight: widget.curItem['fontWeight'],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '€',
                  style: TextStyle(
                    fontSize: widget.curItem["fontSize"] - 3,
                    fontWeight: widget.curItem['fontWeight'],
                    color: widget.curItem["color"],
                  ),
                ),
                TextSpan(
                  text: widget.sizePrice.toString(),
                  style: TextStyle(
                    fontSize: widget.curItem["fontSize"] - 3,
                    fontWeight: widget.curItem['fontWeight'],
                    color: widget.curItem["color"],
                  ),
                ),
              ],
            ),
          )
          // Text(
          //   "|",
          //   style: TextStyle(fontSize: 8, color: widget.curItem["color"]),
          // ),
        ],
      ),
      // ),
    );
  }
}
