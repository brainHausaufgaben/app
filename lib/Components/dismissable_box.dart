import 'package:brain_app/Backend/theming.dart';
import 'package:flutter/material.dart';

class DismissableBox extends StatelessWidget {
  const DismissableBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Dismissible(
            background: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft
                  ),
                )
            ),
            secondaryBackground: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red,
                ),
                child: const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerRight
                  ),
                )
            ),
            key: UniqueKey(),
            direction: DismissDirection.horizontal,
            child: Container(
              constraints: const BoxConstraints.expand(height: 40), // Temporärer fix weil sonst nicht ganze breite
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppDesign.current.boxStyle.backgroundColor,
                  boxShadow: [
                    AppDesign.current.boxStyle.boxShadow
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