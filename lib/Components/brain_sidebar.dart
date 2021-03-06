import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:flutter/material.dart';

class CustomSidebar extends StatefulWidget {
  const CustomSidebar({Key? key}) : super(key: key);

  @override
  _CustomSidebar createState() => _CustomSidebar();
}

class _CustomSidebar extends State<CustomSidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppDesign.current.boxStyle.backgroundColor,
          borderRadius: AppDesign.current.boxStyle.borderRadius,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: Text(
              "Brain Hausaufgabenheft",
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: AppDesign.current.textStyles.color,
                  height: 1.1
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SideBarMenuEntry(
            title: "Noten",
            icon: Icons.grading,
            iconSize: 22,
            activated: NavigationHelper.selectedPrimaryPage.value == 0,
            onTap: () {
              if (NavigationHelper.selectedPrimaryPage.value != 0) {
                NavigationHelper.pushNamedReplacement(context, "gradesOverview");
                setState(() {
                  NavigationHelper.selectedPrimaryPage.value = 0;
                });
              }
            }
          ),
          SideBarMenuEntry(
            title: "Home",
            icon: Icons.home_rounded,
            iconSize: 22,
            activated: NavigationHelper.selectedPrimaryPage.value == 1,
            onTap: () {
              if (NavigationHelper.selectedPrimaryPage.value != 1) {
                NavigationHelper.pushNamedReplacement(context, "home");
                setState(() {
                  NavigationHelper.selectedPrimaryPage.value = 1;
                });
              }
            }
          ),
          SideBarMenuEntry(
            title: "Kalender",
            icon: Icons.calendar_today,
            iconSize: 22,
            activated: NavigationHelper.selectedPrimaryPage.value == 2,
            onTap: () {
              if (NavigationHelper.selectedPrimaryPage.value != 2) {
                NavigationHelper.pushNamedReplacement(context, "calendar");
                setState(() {
                  NavigationHelper.selectedPrimaryPage.value = 2;
                });
              }
            }
          ),
        ],
      ),
    );
  }
}

class SideBarMenuEntry extends StatelessWidget {
  const SideBarMenuEntry({
    Key? key,
    required this.activated,
    required this.onTap,
    required this.title,
    required this.iconSize,
    required this.icon
  }) : super(key: key);

  final bool activated;
  final Function() onTap;
  final String title;
  final IconData icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: activated ? AppDesign.current.primaryColor : AppDesign.current.primaryColor.withOpacity(0)
            ),
            child: Row(
              children: [
                Padding(
                  child: Icon(icon, size: iconSize, color: activated ? AppDesign.current.textStyles.contrastColor : AppDesign.current.textStyles.color),
                  padding: const EdgeInsets.only(right: 10),
                ),
                Text(
                    title,
                    style: TextStyle(
                        color: activated ? AppDesign.current.textStyles.contrastColor : AppDesign.current.textStyles.color,
                        fontSize: 17,
                        fontWeight: FontWeight.w500)
                ),
              ],
            )
        ),
      ),
    );
  }
}