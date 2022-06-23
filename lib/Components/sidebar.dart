import 'package:brain_app/Backend/design.dart';
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
          SideBarMenuEntry(
            title: "Noten",
            activated: BrainApp.selectedPageIndex == 0,
            onTap: () {
              setState(() {
                BrainApp.selectedPageIndex = 0;
              });
            },
          ),
          SideBarMenuEntry(
            title: "Home",
            activated: BrainApp.selectedPageIndex == 1,
            onTap: () {
              setState(() {
                BrainApp.selectedPageIndex = 1;
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) => HomePage(),
                    transitionDuration: const Duration(seconds: 0),
                    reverseTransitionDuration: const Duration(seconds: 0)
                  )
                );
              });
            },
          ),
          SideBarMenuEntry(
            title: "Kalender",
            activated: BrainApp.selectedPageIndex == 2,
            onTap: () {
              setState(() {
                BrainApp.selectedPageIndex = 2;
                Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (context, anim1, anim2) => CalendarPage(),
                        transitionDuration: const Duration(seconds: 0),
                        reverseTransitionDuration: const Duration(seconds: 0)
                    )
                );
              });
            },
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
    required this.title
  }) : super(key: key);

  final bool activated;
  final Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: activated ? AppDesign.current.primaryColor : Colors.transparent
        ),
        child: Text(
            title,
            style: TextStyle(
                color: activated ? AppDesign.current.textStyles.contrastColor : AppDesign.current.textStyles.color,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}