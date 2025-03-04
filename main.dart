import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/call_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/chat': (context) => ChatScreen(),
        '/call': (context) => CallScreen(),
      },
    );
  }
}
