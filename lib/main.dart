import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/lib/github_auth.dart';
import 'package:test_app/pages/camera/camera.dart';
import 'package:test_app/pages/login/login.dart';
import 'package:test_app/pages/main/main.dart';
import 'package:test_app/provider/collection_provier.dart';
import 'package:test_app/provider/setting_provider.dart';
import 'package:test_app/provider/modak_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsChangeNotifier>(
            create: (_) => SettingsChangeNotifier()),
        ChangeNotifierProvider<ModakChangeNotifier>(
            create: (_) => ModakChangeNotifier()),
      ],
      child: MaterialApp(
        title: 'Test App',
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/main': (context) => const Main(),
          '/camera': (context) => CameraPage()
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}

// class Home extends StatefulWidget {
//   Home({Key? key}) : super(key: key);

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> with TickerProviderStateMixin {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       initialIndex: 0,
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           bottom: const TabBar(
//             tabs: [
//               Tab(
//                 icon: Icon(Icons.location_on_outlined),
//               ),
//               Tab(
//                 icon: Icon(Icons.camera_alt_outlined),
//               ),
//               Tab(
//                 icon: Icon(Icons.camera_alt_outlined),
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(children: [
//           GeoLocationPage(),
//           CameraPage(),
//           AuthPage(),
//         ]),
//       ),
//     );
//   }
// }
