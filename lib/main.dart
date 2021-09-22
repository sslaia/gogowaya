import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Part of Flutter excercises
// From https://flutter.dev/docs/cookbook/networking/fetch-data
// and https://flutter.dev/docs/cookbook/networking/background-parsing

Future<List<Photo>> fetchPhotos(http.Client client) async {
  final response = await client.get(
      Uri.parse('https://my-json-server.typicode.com/sslaia/katawaena/photos'));
      // Uri.parse('https://jsonplaceholder.typicode.com/photos'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parsePhotos, response.body);
}

// A function that converts a response body into a List<Photo>.
List<Photo> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
}

class Photo {
  final int albumId;
  final int id;
  final String title;
  final String url;
  final String thumbnailUrl;

  const Photo({
    required this.albumId,
    required this.id,
    required this.title,
    required this.url,
    required this.thumbnailUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      albumId: json['albumId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      url: json['url'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Gogowaya';

    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Photo>>(
        future: fetchPhotos(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return PhotosList(photos: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  const PhotosList({Key? key, required this.photos}) : super(key: key);

  final List<Photo> photos;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          String photoId = photo.id.toString();

          return Card(
            elevation: 8.0,
            child: ListTile(
              leading: Image.network(photos[index].url, fit: BoxFit.cover, width: 50, height: 50,),
              title: Text(photoId),
              subtitle: Text(photos[index].title),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LayarKedua(foto: photo.url)));
              },
            ),
          );
        });
  }
}

class LayarKedua extends StatelessWidget {
  const LayarKedua({Key? key, required this.foto}) : super(key: key);

  final String foto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Foto dari Nias"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Tulis di sini kode untuk pergi ke layar pertama
            // bila tombol "Kembali ke layar pertama!" ditekan
            // Within the SecondRoute widget
            Navigator.pop(context);
          },
          child: Image.network(foto),
        ),
      ),
    );
  }
}
