import 'package:flutter/material.dart';
import 'package:metatube/screens/home_screen.dart';
import 'package:window_manager/window_manager.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  runApp(const MyApp());

  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(500, 750),
    size: Size(500, 750),
    center: true,
    title: "MetaTube",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Meta Tube',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
