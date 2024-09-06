import 'package:dummy_mapstr/pages/home_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          useMaterial3: false, scaffoldBackgroundColor: Color(0x4d605900)),
      home: HomePage(),
      // home: Scaffold(),
    );
  }
}
