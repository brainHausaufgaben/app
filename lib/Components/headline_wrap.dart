import 'package:brain_app/Backend/design.dart';
import 'package:flutter/material.dart';

class HeadlineWrap extends StatelessWidget {
  const HeadlineWrap({
    Key? key,
    required this.children,
    required this.headline
  }) : super(key: key);

  final List<Widget> children;
  final String headline;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              headline,
              style: AppDesign.current.textStyles.boxHeadline
          ),
          Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Wrap(
                runSpacing: 10,
                children: children,
              )
          )
        ]
    );
  }
}
