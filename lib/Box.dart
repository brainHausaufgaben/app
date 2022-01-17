import 'package:flutter/material.dart';
import '../utilities.dart';

class Box extends StatelessWidget {
  const Box({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Stundenplan Heute",
              style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.w600, fontSize:24, height: 0.6
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: AppTheme.mainTextColor,
                  borderRadius: AppTheme.borderRadius
              ),
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
              // Was? Warum? Warum geht das nicht ohne row
              child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Test",
                          style: TextStyle(color: AppTheme.mainColor, fontSize: 15),
                        ),
                        Text(
                          "Test",
                          style: TextStyle(color: AppTheme.mainColor, fontSize: 15),
                        )
                      ],
                    )
                  ]
              ),
            )
          ],
        )
    );
  }
}