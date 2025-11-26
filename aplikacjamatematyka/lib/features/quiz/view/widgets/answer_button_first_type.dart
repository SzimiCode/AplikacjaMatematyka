import 'package:flutter/material.dart';


class AnswerButtonFirstType extends StatelessWidget {
  const AnswerButtonFirstType({
    super.key,
    required this.text,
    required this.onTap
    });

  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      child: Text(text, textAlign: TextAlign.center,),
      
    );
  }
}