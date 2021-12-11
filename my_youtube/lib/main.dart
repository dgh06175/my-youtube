import 'package:flutter/material.dart';
import 'package:my_youtube/screens/main_screen.dart';
// import 'package:my_youtube/screens/channel_search_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter YouTube API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xffff0000),
      ),
      home: MainScreen(),
    );
  }
}