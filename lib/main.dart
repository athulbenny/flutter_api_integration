
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchAlbum(i) async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/todos/${i}'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    //print(Album.fromMap(jsonDecode(response.body)));
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    print('error');
    throw Exception('Failed to load album');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
     required this.userId,
     required this.id,
     required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    //futureAlbum = fetchAlbum(1);
  }
int i=1;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data Example'),
        ),
        body: GestureDetector(
          onTap: (){setState(() {
            i++;print(i);
          });},
          child: Center(
            child: FutureBuilder<Album>(
              future: fetchAlbum(i),
                builder: (context,snapshot) {
                if (snapshot.hasData) {
                  //List<Album> list=snapshot.data;
                  return Text(snapshot.data!.title);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ),
        ),
     ),
    );
  }
}