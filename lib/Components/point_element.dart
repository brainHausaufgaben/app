import 'package:brain_app/Backend/design.dart';
import 'package:flutter/material.dart';

class PointElement extends StatefulWidget {
  const PointElement({
    Key? key,
    required this.color,
    required this.primaryText,
    this.secondaryText,
    this.child
  }) : super(key: key);

  final Color color;
  final String primaryText;
  final String? secondaryText;
  final Widget? child;

  @override
  State<StatefulWidget> createState() =>  _PointElementState();
}

class _PointElementState extends  State<PointElement>{
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      alignment: Alignment.topCenter,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutCirc,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            direction: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5, bottom: 1),
                child: Icon(Icons.circle, color: widget.color, size: 13)
              ),
              Expanded(
                child: Text(widget.primaryText, style: AppDesign.textStyles.pointElementPrimary)
              ),
              if (widget.secondaryText != null) Text(widget.secondaryText!, style: AppDesign.textStyles.pointElementSecondary)
            ]
          ),
          if (widget.child != null) Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: widget.child!,
          )
        ]
      )
    );
  }
}