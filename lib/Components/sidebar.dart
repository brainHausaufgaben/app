import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:brain_app/Pages/calendar_page.dart';
import 'package:brain_app/Pages/home_page.dart';
import 'package:brain_app/main.dart';
import 'package:flutter/material.dart';

class CustomSidebar extends StatefulWidget {
  const CustomSidebar({Key? key}) : super(key: key);

  @override
  _CustomSidebar createState() => _CustomSidebar();
}

class _CustomSidebar extends State<CustomSidebar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppDesign.current.boxStyle.backgroundColor,
          borderRadius: AppDesign.current.boxStyle.borderRadius,
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 20
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
            activated: selectedIndex == 0,
            onTap: () {
              if (selectedIndex != 0) {
                Navigator.of(NavigationHelper.context).pushNamed("/");
                setState(() {
                  selectedIndex = 2;
                });
              }
            }
          ),
          SideBarMenuEntry(
            title: "Home",
            icon: Icons.home_rounded,
            iconSize: 22,
            activated: selectedIndex == 1,
            onTap: () {
              if (selectedIndex != 1) {
                Navigator.of(NavigationHelper.context).pushNamed("/");
                setState(() {
                  selectedIndex = 1;
                });
              }
            }
          ),
          SideBarMenuEntry(
            title: "Kalender",
            icon: Icons.calendar_today,
            iconSize: 22,
            activated: selectedIndex == 2,
            onTap: () {
              if (selectedIndex != 2) {
                Navigator.of(NavigationHelper.context).pushNamed("/calendar");
                setState(() {
                  selectedIndex = 2;
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