import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:feed_segrebot/game.dart';

class App extends StatelessWidget {
  final materialApp = MaterialApp(
    title: "Feed Segrebot",
    theme: ThemeData(
      primaryColor: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    showPerformanceOverlay: false,
    home: Game(),
    routes: <String, WidgetBuilder>{
      "routeGame": (BuildContext context) => Game(),
    },
  );

  @override
  Widget build(BuildContext context) {
    return materialApp;
  }
}
