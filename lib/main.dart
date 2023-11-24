import 'package:flutter/material.dart';
import 'package:test_app/pages/auth/auth.dart';
import 'package:test_app/pages/camera/camera.dart';
import 'package:test_app/pages/geolocation/geolocation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.location_on_outlined),
              ),
              Tab(
                icon: Icon(Icons.camera_alt_outlined),
              ),
              Tab(
                icon: Icon(Icons.camera_alt_outlined),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          GeoLocationPage(),
          CameraPage(),
          AuthPage(),
        ]),
      ),
    );
  }
}
