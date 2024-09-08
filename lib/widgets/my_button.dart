import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Widget widget;
  final VoidCallback? action;

  const MyButton({required this.widget, required this.action, super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: action,
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.blue,
            ),
            child: Center(child: widget)));
  }
}
