import 'package:flutter/material.dart';
import '../utilities.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.headline != null) Text(
                widget.headline!,
                style: const TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600, fontSize:24, height: 0.6)
            ),
            Padding(
              padding: widget.headline != null ? const EdgeInsets.only(top: 8) : const EdgeInsets.only(),
              child:
              Container(
                  decoration: BoxDecoration(
                      color: AppTheme.mainTextColor,
                      borderRadius: AppTheme.borderRadius
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                  // Was? Warum? Warum geht das nicht ohne row
                  child:
                  widget.child
              ),
            )
          ])
    );
  }
}