import 'package:flutter/material.dart';
import 'package:test_app/pages/main/collections.dart';
import 'package:test_app/pages/main/profile.dart';

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: const TabBar(tabs: [
          Tab(icon: Icon(Icons.account_circle_outlined)),
          Tab(icon: Icon(Icons.collections))
        ]),
        body: TabBarView(children: [
          Profile(),
          CollectionPage(),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/camera'),
          child: const Icon(Icons.camera),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
