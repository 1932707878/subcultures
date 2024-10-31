import 'package:flutter/material.dart';
import 'package:subcultures/routes/route_utils.dart';
import 'package:subcultures/routes/routes.dart';

class Subcultures extends StatelessWidget {
  const Subcultures({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      navigatorKey: RouteUtils.navigatorKey,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: RoutePath.tab,
    );
  }
}
