import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Destination Info',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 186, 231, 215)),
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
  Future<List<dynamic>> fetchCountries() async {
    final response = await http.get(Uri.parse('http://localhost:5000/countries'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load countries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.location_on_sharp), text: 'Destination'),
              Tab(icon: Icon(Icons.favorite_outlined), text: 'Favorite'),
              Tab(icon: Icon(Icons.info), text: 'Info'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Home Tab')),
            FutureBuilder<List<dynamic>>(
              future: fetchCountries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final countries = snapshot.data!;
                  return ListView.builder(
                    itemCount: countries.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(countries[index]['name']),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CountryDetail(id: countries[index]['id']),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
            Center(child: Text('Favorite Tab')),
            Center(child: Text('Information Tab')),
          ],
        ),
      ),
    );
  }
}

class CountryDetail extends StatelessWidget {
  final int id;

  const CountryDetail({Key? key, required this.id}) : super(key: key);

  Future<Map<String, dynamic>> fetchCountryDetail() async {
    final response = await http.get(Uri.parse('http://localhost:5000/countries/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load country details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchCountryDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final country = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${country['name']}', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 8),
                  Text('Details: ${country['details']}', style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

