import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_finder/view/movie_list.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "Movie Finder",
    home: MovieScreen(),
    debugShowCheckedModeBanner: false,
  ));
}