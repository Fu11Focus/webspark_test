import 'package:flutter/material.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? result =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    List<Map<String, Color>> matrix = [];
    if (result != null && result['result'] != null) {
      for (int i = 0; i < result['exersice']['field'][0].length; i++) {
        for (int j = 0; j < result['exersice']['field'][0].length; j++) {
          matrix.add({'$j,$i': const Color(0xffffffff)});
        }
      }

      List<List<int>> block = [];
      for (int i = 0; i < result['exersice']['field'].length; i++) {
        for (int j = 0; j < result['exersice']['field'][i].length; j++) {
          if (result['exersice']['field'][i][j] == 'X') {
            block.add([j, i]);
          }
        }
      }
      print(block);

      for (int i = 0; i < result['exersice']['field'][0].length; i++) {
        for (int j = 0; j < result['exersice']['field'][0].length; j++) {
          String key = '$j,$i';

          if (result['exersice']['start']['x'] == j &&
              result['exersice']['start']['y'] == i) {
            matrix[matrix.indexWhere((element) => element.keys.first == key)] =
                {key: const Color(0xff64FFDA)};
          } else if (result['exersice']['end']['x'] == j &&
              result['exersice']['end']['y'] == i) {
            matrix[matrix.indexWhere((element) => element.keys.first == key)] =
                {key: const Color(0xff009688)};
          } else if (block.any((b) => b[0] == j && b[1] == i)) {
            // Изменена проверка на блокированные ячейки
            matrix[matrix.indexWhere((element) => element.keys.first == key)] =
                {key: const Color(0xff000000)};
          } else if (result['result']['steps']
              .any((step) => step['x'] == j && step['y'] == i)) {
            // Проверка на шаги
            matrix[matrix.indexWhere((element) => element.keys.first == key)] =
                {key: const Color(0xff4CAF50)};
          }
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Preview screen'),
        ),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width,
              child: GridView.count(
                  crossAxisCount: result!['exersice']['field'][0].length,
                  children: List.generate(
                    matrix.length,
                    (index) {
                      final Map<String, Color> item = matrix[index];
                      final String key = item.keys.first;
                      final Color color = item.values.first;
                      return Container(
                        decoration:
                            BoxDecoration(border: Border.all(), color: color),
                        child: Center(
                          child: Text(
                            key,
                            style: TextStyle(
                                color: color == Color(0xff000000)
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ),
                      );
                    },
                  )),
            ),
            if (result != null && result['result'] != null)
              Text(
                result['result']['path'],
                textAlign: TextAlign.center,
              )
            else
              const Text(
                'No data',
                textAlign: TextAlign.center,
              ),
          ],
        ));
  }
}
