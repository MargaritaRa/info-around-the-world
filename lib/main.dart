import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Info Around the World'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // creates the tab controller
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        // creates the tabs
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'home'),
              Tab(icon: Icon(Icons.location_on_sharp), text: 'Destination'),
              //Tab(icon: Icon(Icons.add_location_alt), text: 'Destination'),
              Tab(icon: Icon(Icons.favorite_outlined), text: 'Favorite'),
              Tab(icon: Icon(Icons.info), text: 'Info'),
            ],
          ),
        ),
        // creates the content for each tab
        body: const TabBarView(
          children: [
            Center(child: Text('Home Tab')),
            Center(child: Text('Destination Tab')),
            Center(child: Text('Favorite Tab')),
            Center(child: Text('Information Tab')),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

