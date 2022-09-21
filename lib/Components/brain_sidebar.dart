import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Components/navigation_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomSidebar extends StatefulWidget {
  const CustomSidebar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomSidebar();
}

class _CustomSidebar extends State<CustomSidebar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppDesign.colors.secondaryBackground,
          borderRadius: AppDesign.boxStyle.borderRadius,

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
                  color: AppDesign.colors.text,
                  height: 1.1
              ),
              textAlign: TextAlign.center,
            )
          ),
          AnimatedBuilder(
            animation: NavigationHelper.selectedPrimaryPage,
            builder: (context, child) {
              return Column(
                children: [
                  SideBarMenuEntry(
                      title: "Noten",
                      icon: Icons.grading,
                      iconSize: 22,
                      activated: NavigationHelper.selectedPrimaryPage.value == 0,
                      onTap: () {
                        NavigationHelper.pushNamedReplacement(context, "gradesOverview");
                        NavigationHelper.selectedPrimaryPage.value = 0;
                      }
                  ),
                  SideBarMenuEntry(
                      title: "Home",
                      icon: Icons.home_rounded,
                      iconSize: 22,
                      activated: NavigationHelper.selectedPrimaryPage.value == 1,
                      onTap: () {
                        NavigationHelper.pushNamedReplacement(context, "home");
                        NavigationHelper.selectedPrimaryPage.value = 1;
                      }
                  ),
                  SideBarMenuEntry(
                      title: "Kalender",
                      icon: Icons.calendar_month_rounded,
                      iconSize: 22,
                      activated: NavigationHelper.selectedPrimaryPage.value == 2,
                      onTap: () {
                        NavigationHelper.pushNamedReplacement(context, "calendar");
                        NavigationHelper.selectedPrimaryPage.value = 2;
                      }
                  )
                ]
              );
            }
          ),
          if (kIsWeb) ...[
            Divider(
              height: 30,
              thickness: 2,
              color: AppDesign.colors.text.withOpacity(0.1),
              indent: 30,
              endIndent: 30,
            ),
            Container(
                margin: const EdgeInsets.only(top: 10),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    border: Border.all(color: AppDesign.colors.text, width: 2),
                    borderRadius: AppDesign.boxStyle.inputBorderRadius
                ),
                child: TextButton(
                    onPressed: () {
                      if (kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
                        Uri url = Uri.parse("https://play.google.com/store/apps/details?id=com.brain.brain_app");
                        launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    constraints: const BoxConstraints(maxWidth: 400),
                                    child: AlertDialog(
                                      backgroundColor: AppDesign.colors.primary,
                                      title: Text(
                                        "Lade die Brain App auf deinem Android Gerät herunter",
                                        style: AppDesign.textStyles.alertDialogHeader.copyWith(color: AppDesign.colors.contrast)),
                                      content: const Center(
                                        child: Image(image: AssetImage("images/qr_code.png"), width: 200, height: 200),
                                      ),
                                      contentPadding: const EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 60),
                                    ),
                                  )
                                ],
                              );
                            }
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Herunterladen ", style: TextStyle(
                              color: AppDesign.colors.text,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                          )
                          ),
                          Icon(Icons.phone_android_rounded, color: AppDesign.colors.text)
                        ]
                    )
                )
            )
          ]
        ]
      )
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: activated ? AppDesign.colors.background : AppDesign.colors.background.withOpacity(0),
        borderRadius: BorderRadius.circular(9)
      ),
      clipBehavior: Clip.antiAlias,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: AppDesign.colors.primary,
          padding: const EdgeInsets.all(5),
        ),
        child: Row(
          children: [
            AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                    color: activated ? AppDesign.colors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(9)
                ),
                child: Icon(icon, size: iconSize, color: activated ? AppDesign.colors.contrast : AppDesign.colors.text08)
            ),
            Text(
                title,
                style: TextStyle(
                    color: activated ? AppDesign.colors.text : AppDesign.colors.text08,
                    fontSize: 16,
                    fontWeight: activated ? FontWeight.w700 : FontWeight.w600
                )
            )
          ]
        )
      )
    );
  }
}