import 'package:flutter/material.dart';
import 'package:task/pages/files_page.dart';
import 'package:task/pages/home_page.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/file': (context) => const FilesProgress(),
    },
    home: MenuItem(),
  ));
}
