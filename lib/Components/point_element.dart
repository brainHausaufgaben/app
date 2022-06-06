import 'package:flutter/material.dart';
import 'package:brain_app/Backend/theming.dart';

class PointElement extends StatefulWidget {
  PointElement({Key? key, required this.color, required this.primaryText, this.secondaryText, this.child}) : super(key: key);
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
    return Flex(
      direction: Axis.horizontal,
      crossAxisAlignment: widget.child == null ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Row(
            crossAxisAlignment: widget.child != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 5, bottom: 3),
                  child: Icon(Icons.circle, color: widget.color, size: 13)
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.primaryText, style: AppDesign.current.textStyles.pointElementPrimary),
                    if (widget.child != null) widget.child!
                  ],
                ),
              )
            ],
          ),
        ),
        if (widget.secondaryText != null) Text(widget.secondaryText!)
      ],
    );
  }
}