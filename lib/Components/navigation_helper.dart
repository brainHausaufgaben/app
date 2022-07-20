import 'package:brain_app/Backend/design.dart';
import 'package:brain_app/Backend/navigator_routes.dart';
import 'package:brain_app/Components/sidebar.dart';
import 'package:flutter/material.dart';

import 'package:brain_app/Components/custom_navigation_bar.dart';
import 'package:flutter/services.dart';

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

  static void push(Widget route) {
    navigator.push(
        getRouteBuilder(null, route: route)
    );
  }

  static FadeTransition transitionBuilder(context, animation, secondaryAnimation, child) {
    const begin = 0.0;
    const end = 1.0;
    final tween = Tween(begin: begin, end: end);
    final offsetAnimation = animation.drive(tween);

    return FadeTransition(
      opacity: offsetAnimation,
      child: child,
    );
  }

  static PageRoute getRouteBuilder(RouteSettings? routeSettings, {String? routeName, Widget? route}) {
    Map<String, WidgetBuilder> routes = NavigatorRoutes.get();

    if (MediaQuery.of(context).size.width > AppDesign.breakPointWidth) {
      return PageRouteBuilder(
        pageBuilder: (context, a1, a2) => route ?? routes[routeName ?? routeSettings?.name]!(context),
        transitionsBuilder: transitionBuilder,
      );
    } else {
      return MaterialPageRoute(
          builder: (context) => route ?? routes[routeName ?? routeSettings?.name]!(context)
      );
    }
  }

  @override
  _NavigationHelper createState() => _NavigationHelper();
}

class _NavigationHelper extends State<NavigationHelper> {
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
    Widget navigator = Navigator(
        key: NavigationHelper.navigatorKey,
        initialRoute: "/home",
        onGenerateRoute: (routeSettings) {
          if (routeSettings.name == "/") {
            return NavigationHelper.getRouteBuilder(routeSettings, routeName: "/home");
          } else {
            return NavigationHelper.getRouteBuilder(routeSettings);
          }
        }
    );

    return Scaffold(
      body: MediaQuery.of(context).size.width > AppDesign.breakPointWidth
          ? wrapInSidebar(navigator)
          : navigator,
      bottomNavigationBar: MediaQuery.of(context).size.width > AppDesign.breakPointWidth ? null : CustomNavigationBar(),
    );
  }
}