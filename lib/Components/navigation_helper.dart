import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/navigator_routes.dart';
import 'package:brain_app/Components/sidebar.dart';
import 'package:flutter/material.dart';

import 'package:brain_app/Components/custom_navigation_bar.dart';

class NavigationHelper extends StatefulWidget {
  const NavigationHelper({Key? key}) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static BuildContext get context => navigatorKey.currentContext!;

  static NavigatorState get navigator {
    if (MediaQuery.of(context).size.width > AppDesign.breakPointWidth) {
      return Navigator.of(context);
    } else {
      return Navigator.of(context, rootNavigator: true);
    }
  }

  static void pushNamed(String routeName) {
    navigator.pushNamed(routeName);
  }

  @override
  _NavigationHelper createState() => _NavigationHelper();
}

class _NavigationHelper extends State<NavigationHelper> {
  bool showNavigationBar = true;

  Widget wrapInSidebar(Widget child) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 1300),
          child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomSidebar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: child,
                  ),
                )
              ]
          )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = NavigatorRoutes.get();

    Widget navigator = Navigator(
        key: NavigationHelper.navigatorKey,
        initialRoute: "/home",
        onGenerateRoute: (routeSettings) {
          if (routeSettings.name == "/") {
            return MaterialPageRoute(
              builder: (context) => routes["/home"]!(context),
            );
          }
          return MaterialPageRoute(
            builder: (context) => routes[routeSettings.name]!(context),
          );
        }
    );

    return Scaffold(
      body: MediaQuery.of(context).size.width > AppDesign.breakPointWidth
          ? wrapInSidebar(navigator)
          : navigator,
      bottomNavigationBar: MediaQuery.of(context).size.width > AppDesign.breakPointWidth || !showNavigationBar ? null : CustomNavigationBar(),
    );
  }
}