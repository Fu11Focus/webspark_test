import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:webspark_test/widgets/my_button.dart';

import '../services/service_api_webspark.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();

  void onStart() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _customErrorMessage = null;
      });
      //save link to DB
      var box = Hive.box('linkBox');
      box.put('link', controller.text);
      //fetch to server
      ServiceApiWebspark service = ServiceApiWebspark();
      var data = await service.fetchExercise(box.get('link'));
      Navigator.pushNamed(context, '/processScreen', arguments: data);
    } else {
      setState(() {
        _customErrorMessage = 'Set valid API base URL in  order to continue';
      });
    }
  }

  TextEditingController controller = TextEditingController();
  String? _customErrorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_customErrorMessage != null)
                  Text(
                    _customErrorMessage!,
                  ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(Icons.compare_arrows),
                    ),
                    Expanded(
                        child: Form(
                      key: formKey,
                      child: TextFormField(
                        validator: (value) =>
                            value != 'https://flutter.webspark.dev/flutter/api'
                                ? ''
                                : null,
                        controller: controller,
                      ),
                    ))
                  ],
                )
              ],
            ),
            MyButton(
                widget: const Text('Start counting process'), action: onStart)
          ],
        ),
      ),
    );
  }
}
