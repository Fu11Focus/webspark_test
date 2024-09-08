import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webspark_test/models/result_model.dart';
import 'package:webspark_test/services/service_api_webspark.dart';
import 'package:webspark_test/widgets/my_button.dart';

class ProcessPage extends StatefulWidget {
  const ProcessPage({super.key});

  @override
  State<ProcessPage> createState() => _ProcessPageState();
}

class _ProcessPageState extends State<ProcessPage> {
  double progress = 0.0;
  bool calculationsComplete = false;
  bool sendResultCompleted = false;
  bool sending = false;
  late ResultModel resultModel;
  List resultList = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var exercises = ModalRoute.of(context)?.settings.arguments as List;
      calculateExercise(exercises);
    });
  }

  Future<void> calculateExercise(List exercises) async {
    int totalExercises = exercises.length;
    for (int i = 0; i < totalExercises; i++) {
      var element = exercises[i];
      var steps = shortestPath(
        element['field'][0].length,
        element['field'],
        [element['start']['x'], element['start']['y']],
        [element['end']['x'], element['end']['y']],
      );
      List<Map> parseSteps = [];
      String path = '';
      for (int i = 0; i < steps.length; i++) {
        parseSteps.add({'x': steps[i][0], 'y': steps[i][1]});
        // создаем строку пути
        if (i == steps.length - 1) {
          path = '$path(${steps[i][0]},${steps[i][1]})';
        } else {
          path = '$path(${steps[i][0]},${steps[i][1]})->';
        }
      }

      setState(() {
        progress = (i + 1) / totalExercises;
      });

      resultModel = ResultModel(
          id: element['id'],
          result: {
            'steps': parseSteps,
            'path': path,
          },
          exersice: element);
      resultList.add(resultModel);
      await Future.delayed(const Duration(milliseconds: 500));
    }

    setState(() {
      calculationsComplete = true;
    });
  }

  void onSendResult() async {
    setState(() {
      sending = true;
    });
    ServiceApiWebspark service = ServiceApiWebspark();
    for (var element in resultList) {
      Hive.box('resultsBox').put(element.id.toString(), {
        'id': element.id,
        'result': element.result,
        'exersice': element.exersice
      });
      await service.sendCountingResult(Hive.box('linkBox').getAt(0),
          {'id': element.id, 'result': element.result});
    }
    setState(() {
      sending = false;
    });
    Navigator.pushNamed(context, '/resultScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Process Screen')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    calculationsComplete
                        ? 'All calculations have finished, you can send your results to the server'
                        : 'Calculating...',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text('${(progress * 100).toInt()}%'),
                  const SizedBox(height: 16),
                  CircularProgressIndicator(
                    value: progress,
                  ),
                ],
              ),
            ),
            MyButton(
              widget: sending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Text('Send results to server'),
              action: calculationsComplete
                  ? onSendResult
                  : null, // кнопка становится неактивной до завершения расчетов
            )
          ],
        ),
      ),
    );
  }
}

List<List<int>> shortestPath(
    int n, List blocked, List<int> start, List<int> end) {
  List<List<int>> directions = [
    [0, 1],
    [1, 0],
    [0, -1],
    [-1, 0],
    [-1, -1],
    [-1, 1],
    [1, -1],
    [1, 1],
  ];

  List<List<bool>> grid =
      List.generate(n, (_) => List.generate(n, (_) => true));

  for (int i = 0; i < blocked.length; i++) {
    for (int j = 0; j < blocked[i].length; j++) {
      if (blocked[i][j] == 'X') {
        grid[i][j] = false;
      }
    }
  }

  bool isValid(int x, int y) {
    return x >= 0 && x < n && y >= 0 && y < n && grid[x][y];
  }

  if (!isValid(start[0], start[1]) || !isValid(end[0], end[1])) {
    return [];
  }

  Queue<List<dynamic>> queue = Queue();
  queue.add([start, []]);

  Set<String> visited = {};
  visited.add('${start[0]}-${start[1]}');

  while (queue.isNotEmpty) {
    var current = queue.removeFirst();
    var currentPos = current[0];
    var path = List<List<int>>.from(current[1]);

    path.add(currentPos);

    if (currentPos[0] == end[0] && currentPos[1] == end[1]) {
      return path;
    }

    for (var direction in directions) {
      int newX = currentPos[0] + direction[0];
      int newY = currentPos[1] + direction[1];

      if (isValid(newX, newY) && !visited.contains('$newX-$newY')) {
        visited.add('$newX-$newY');
        queue.add([
          [newX, newY],
          path
        ]);
      }
    }
  }

  return [];
}
