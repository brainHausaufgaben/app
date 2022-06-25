import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/navigator_routes.dart';
import 'package:brain_app/Components/sidebar.dart';
import 'package:flutter/material.dart';

import 'package:brain_app/Components/custom_navigation_bar.dart';

class NavigationHelper extends StatefulWidget {
  const NavigationHelper({Key? key}) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static BuildContext get context => navigatorKey.currentContext!;

  static void pushNamed(String routeName) {
    if (MediaQuery.of(context).size.width > AppDesign.breakPointWidth) {
      Navigator.of(context).pushNamed(routeName);
    } else {
      Navigator.of(context, rootNavigator: true).pushNamed(routeName);
    }
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
          constraints: const BoxConstraints(maxWidth: 1200),
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

  Widget test(BuildContext context) {
    return const Text("hey");
  }

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = NavigatorRoutes.get();

    Widget navigator = KeyedSubtree(
      child: Navigator(
          key: NavigationHelper.navigatorKey,
          initialRoute: "/home",
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(
              builder: (context) => routes[routeSettings.name]!(context),
            );
          }
      ),
    );

    return Scaffold(
      body: MediaQuery.of(context).size.width > AppDesign.breakPointWidth
          ? wrapInSidebar(navigator)
          : navigator,
      bottomNavigationBar: MediaQuery.of(context).size.width > AppDesign.breakPointWidth || !showNavigationBar ? null : CustomNavigationBar(),
    );
  }
}