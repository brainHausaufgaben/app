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
              color: AppDesign.current.boxStyle.backgroundColor,
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
                child: GestureDetector(
                    onTap: () {
                      if (NavigationHelper.selectedPrimaryPage.value != 0) {
                        NavigationHelper.pushNamedReplacement(context, "gradesOverview");
                        setState(() {
                          NavigationHelper.selectedPrimaryPage.value = 0;
                        });
                      }
                    },
                    child: NavigationItem(
                      title: "Noten",
                      icon: Icons.grading,
                      iconSize: 22,
                      activated: NavigationHelper.selectedPrimaryPage.value == 0,
                    )
                ),
              ),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      if (NavigationHelper.selectedPrimaryPage.value != 1) {
                        NavigationHelper.pushNamedReplacement(context, "home");
                        setState(() {
                          NavigationHelper.selectedPrimaryPage.value = 1;
                        });
                      }
                    },
                    child: NavigationItem(
                      title: "Home",
                      icon: Icons.home_rounded,
                      iconSize: 25,
                      activated: NavigationHelper.selectedPrimaryPage.value == 1,
                    )
                ),
              ),
              Flexible(
                child: GestureDetector(
                    onTap: () {
                      if (NavigationHelper.selectedPrimaryPage.value != 2) {
                        NavigationHelper.pushNamedReplacement(context, "calendar");
                        setState(() {
                          NavigationHelper.selectedPrimaryPage.value = 2;
                        });
                      }
                    },
                    child: NavigationItem(
                      title: "Kalender",
                      icon: Icons.calendar_today,
                      iconSize: 20,
                      activated: NavigationHelper.selectedPrimaryPage.value == 2,
                    )
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class NavigationItem extends StatelessWidget {
  const NavigationItem({Key? key, required this.title, required this.icon, required this.iconSize, required this.activated}) : super(key: key);

  final String title;
  final IconData icon;
  final double iconSize;
  final bool activated;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
            color: activated ? AppDesign.current.primaryColor : AppDesign.current.primaryColor.withAlpha(0),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              child: Icon(icon, size: iconSize, color: activated ? AppDesign.current.textStyles.contrastColor : AppDesign.current.textStyles.color),
              padding: const EdgeInsets.only(right: 5),
            ),
            AnimatedSize(
              alignment: Alignment.centerLeft,
              duration: const Duration(milliseconds: 200),
              child: Text(activated ? title : "", style: TextStyle(color: AppDesign.current.textStyles.contrastColor , fontSize: 14, fontWeight: FontWeight.w600)),
            )
          ],
        ),
      ),
    );
  }
}