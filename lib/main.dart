import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webspark_test/pages/process_page.dart';
import 'package:webspark_test/pages/result_page.dart';

import 'data/result_hive.dart';
import 'pages/home_page.dart';
import 'pages/preview_page.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('linkBox');
  Hive.registerAdapter(ResultModelAdapter());
  await Hive.openBox('resultsBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      routes: {
        '/processScreen': (context) => const ProcessPage(),
        '/resultScreen': (context) => ResultPage(),
        '/previewScreen': (context) => const PreviewPage()
      },
    );
  }
}
