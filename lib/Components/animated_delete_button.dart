import 'package:flutter/material.dart';

import '../Backend/design.dart';
import 'brain_toast.dart';

class AnimatedDeleteButton extends StatefulWidget {
  const AnimatedDeleteButton({
    super.key,
    required this.onDelete
  });

  final Function() onDelete;

  @override
  State<StatefulWidget> createState() => _AnimatedDeleteButton();
}

class _AnimatedDeleteButton extends State<AnimatedDeleteButton> with TickerProviderStateMixin {
  late AnimationController controller;
  late CurvedAnimation animation;

  @override
  void dispose() {
    animation.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        value: 1.0,
        vsync: this,
        duration: const Duration(milliseconds: 750),
        reverseDuration: const Duration(milliseconds: 750)
    );
    animation = CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
            onTapDown: (details) => controller.reverse(),
            onTapUp: (details) {
              if (controller.value > 0.9) {
                BrainToast toast = BrainToast(text: "Lange halten um zu löschen");
                toast.show();
              } else if (controller.value == 0) {
                widget.onDelete();
              }
              controller.forward();
            },
            onTapCancel: () => controller.forward(),
            child: Container(
                decoration: BoxDecoration(
                    color: AppDesign.colors.secondaryBackground,
                    borderRadius: AppDesign.boxStyle.inputBorderRadius
                ),
                width: 50,
                height: 50,
                child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(Icons.delete_forever, color: AppDesign.colors.text),
                      AnimatedBuilder (
                          animation: animation,
                          builder: (context, child) {
                            return ClipRect(
                              clipper: ScaleClipper(animation.value * 51),
                              child: Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: AppDesign.colors.primary,
                                      borderRadius: AppDesign.boxStyle.inputBorderRadius
                                  ),
                                  child: Center(
                                    child: Icon(Icons.delete_forever, color: AppDesign.colors.contrast),
                                  )
                              ),
                            );
                          }
                      )
                    ]
                )
            )
        )
    );
  }
}

class ScaleClipper extends CustomClipper<Rect> {
  double value;

  ScaleClipper(this.value);

  @override
  Rect getClip(Size size) {
    Rect rect = Rect.fromLTWH(0.0, 0.0 + value, size.width, size.height);
    return rect;
  }

  @override
  bool shouldReclip(ScaleClipper oldClipper) {
    return true;
  }
}