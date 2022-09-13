import 'package:brain_app/Backend/design.dart';
import 'package:flutter/material.dart';

import 'navigation_helper.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomNavigationBar createState() => _CustomNavigationBar();
}

class _CustomNavigationBar extends State<CustomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: NavigationHelper.selectedPrimaryPage,
      builder: (context, child) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 56,
          decoration: BoxDecoration(
              color: AppDesign.colors.secondaryBackground,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20
                )
              ]
          ),
          child: Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: NavigationItem(
                    title: "Noten",
                    icon: Icons.grading,
                    iconSize: 22,
                    activated: NavigationHelper.selectedPrimaryPage.value == 0,
                    action: () {
                      if (NavigationHelper.selectedPrimaryPage.value != 0) {
                        NavigationHelper.pushNamedReplacement(context, "gradesOverview");
                        setState(() {
                          NavigationHelper.selectedPrimaryPage.value = 0;
                        });
                      }
                    }
                )
              ),
              Flexible(
                child: NavigationItem(
                    title: "Home",
                    icon: Icons.home_rounded,
                    iconSize: 25,
                    activated: NavigationHelper.selectedPrimaryPage.value == 1,
                    action: () {
                      if (NavigationHelper.selectedPrimaryPage.value != 1) {
                        NavigationHelper.pushNamedReplacement(context, "home");
                        setState(() {
                          NavigationHelper.selectedPrimaryPage.value = 1;
                        });
                      }
                    }
                )
              ),
              Flexible(
                child: NavigationItem(
                    title: "Kalender",
                    icon: Icons.calendar_month_rounded,
                    iconSize: 20,
                    activated: NavigationHelper.selectedPrimaryPage.value == 2,
                    action: () {
                      if (NavigationHelper.selectedPrimaryPage.value != 2) {
                        NavigationHelper.pushNamedReplacement(context, "calendar");
                        setState(() {
                          NavigationHelper.selectedPrimaryPage.value = 2;
                        });
                      }
                    }
                )
              )
            ]
          )
        );
      }
    );
  }
}

class NavigationItem extends StatefulWidget {
  const NavigationItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.iconSize,
    required this.activated,
    required this.action
  }) : super(key: key);

  final String title;
  final IconData icon;
  final double iconSize;
  final bool activated;
  final Function() action;

  @override
  State<StatefulWidget> createState() => _NavigationItem();
}

class _NavigationItem extends State<NavigationItem> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400)
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activated) {
      controller.forward();
    } else {
      controller.reverse();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
            color: widget.activated ? AppDesign.colors.primary : Colors.transparent,
            borderRadius: AppDesign.boxStyle.borderRadius
        ),
        clipBehavior: Clip.antiAlias,
        child: TextButton(
          onPressed: widget.action,
          style: TextButton.styleFrom(
              primary: widget.activated ? AppDesign.colors.contrast : AppDesign.colors.primary
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                child: Icon(widget.icon, size: widget.iconSize, color: widget.activated ? AppDesign.colors.contrast : AppDesign.colors.text),
                padding: const EdgeInsets.only(right: 5),
              ),
              SizeTransition(
                axis: Axis.horizontal,
                axisAlignment: -1,
                sizeFactor: CurvedAnimation(
                  parent: controller,
                  curve: Curves.easeInOutBack,
                ),
                child: Center(
                  child: Text(widget.title, style: TextStyle(color: AppDesign.colors.contrast , fontSize: 14, fontWeight: FontWeight.w600)),
                )
              )
            ]
          )
        )
      )
    );
  }
}