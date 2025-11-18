import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

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
            ElevatedButton(
              onPressed: () { 
                selectedPageNotifier.value = 5;
              },
              child: (
                Text("Idz do quiz pierwszy typ")
              ),
            )
          ],
        ),
    );
  }
}
