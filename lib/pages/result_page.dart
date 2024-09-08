import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ResultPage extends StatelessWidget {
  ResultPage({super.key});
  List results = Hive.box('resultsBox').values.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Result list screen')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) => GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/previewScreen',
                        arguments: results[index]),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        margin: const EdgeInsets.only(bottom: 4),
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          results[index]['result']['path'],
                          textAlign: TextAlign.center,
                        )),
                  )),
        ));
  }
}
