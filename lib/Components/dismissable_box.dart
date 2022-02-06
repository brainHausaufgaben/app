import 'package:brain_app/Backend/theming.dart';
import 'package:flutter/material.dart';

class DismissableBox extends StatelessWidget {
  const DismissableBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.horizontal,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppDesign.current.boxStyle.backgroundColor,
                boxShadow: [
                  BoxShadow(
                      color: AppDesign.current.primaryColor.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: const Offset(0, 1)
                  ),
                ]
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text("Sussy", style: AppDesign.current.textStyles.pointElementSecondary),
            ),
          )
      ),
    );
  }
}