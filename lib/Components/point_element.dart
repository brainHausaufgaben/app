import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../utilities.dart';

class PointElement extends StatefulWidget {
  PointElement({Key? key, required this.color, required this.primaryText,this.secondaryText,this.child}) : super(key: key);
  Color color;
  String primaryText;
  String? secondaryText;
  Widget? child;


  @override
  State<StatefulWidget> createState() =>  _PointElementState();

}
class _PointElementState extends  State<PointElement>{
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Icon(Icons.circle, color:widget.color,size: 13)
        ),
        Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start   ,
            children: [
              Text(
                widget.primaryText,
                style: const TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w400, fontSize:17,height: 1),
              ),
              if (widget.child != null) widget.child!
            ],
          ),
        ),
        if (widget.secondaryText != null) Text(widget.secondaryText!)
      ],
    );
  }

}