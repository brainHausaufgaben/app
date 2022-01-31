import 'package:flutter/material.dart';
import '../utilities.dart';

class Box extends StatefulWidget {
   Box({Key? key, required this.child}) : super(key: key);
   Widget child;

  @override
  State<StatefulWidget> createState() =>  _BoxState();

  }
class _BoxState extends  State<Box>{

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
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
            );
  }

}