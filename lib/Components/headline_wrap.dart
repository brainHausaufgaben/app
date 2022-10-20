import 'package:brain_app/Backend/design.dart';
import 'package:flutter/material.dart';

class HeadlineWrap extends StatelessWidget {
  const HeadlineWrap({
    Key? key,
    required this.children,
    required this.headline,
    this.action
  }) : super(key: key);

  final List<Widget> children;
  final String headline;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  headline,
                  style: AppDesign.textStyles.boxHeadline
              ),
              if (action != null) action!
            ],
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
