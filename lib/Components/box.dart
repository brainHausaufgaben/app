import 'package:brain_app/Backend/design.dart';
import 'package:flutter/material.dart';

class Box extends StatefulWidget {
   Box({Key? key, required this.child, this.headline}) : super(key: key);
   Widget child;
   String? headline;

  @override
  State<StatefulWidget> createState() =>  _BoxState();

  }
class _BoxState extends  State<Box>{

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.headline != null) Text(
          widget.headline!,
          style: AppDesign.current.textStyles.boxHeadline
        ),
        Padding(
          padding: widget.headline != null ? const EdgeInsets.only(top: 8) : const EdgeInsets.only(),
          child: Container(
            decoration: BoxDecoration(
              color: AppDesign.current.boxStyle.backgroundColor,
              borderRadius: AppDesign.current.boxStyle.borderRadius
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            child: widget.child
          )
        )
      ]
    );
  }
}