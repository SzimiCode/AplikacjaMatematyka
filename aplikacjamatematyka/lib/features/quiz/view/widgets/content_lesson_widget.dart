import 'package:flutter/material.dart';

class ContentLessonWidget extends StatelessWidget {
  final int number;
  final String title;

  const ContentLessonWidget({
    super.key,
    required this.number,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20), 
        child: Row(
          children: [
            Container(
              child: Text("Lesson"),
            ),
          ],
        ),
    );
  }
}
