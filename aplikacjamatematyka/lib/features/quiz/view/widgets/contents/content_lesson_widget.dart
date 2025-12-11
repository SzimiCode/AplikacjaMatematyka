import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/help_widgets_weird_ones/row_right.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/help_widgets_weird_ones/row_left.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/help_widgets_weird_ones/dot_trail_left.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/help_widgets_weird_ones/dot_trail_right.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';

class ContentLessonWidget extends StatelessWidget {
  const ContentLessonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            const DotTrailLeft(),

            RowLeft(
              icon: Icons.camera_alt,
              asset: 'assets/images/knight.png',
              onTap: () {
                selectedPageNotifier.value = 8;
              },
            ),

            const DotTrailRight(),

            RowRight(
              icon: Icons.menu_book,
              asset: 'assets/images/treasurechest.png',
              onTap: () {
                selectedPageNotifier.value = 9;
              },
            ),

            const DotTrailLeft(),

            RowLeft(
              icon: Icons.emoji_events,
              asset: 'assets/images/dragon1.png',
              onTap: () {
                selectedPageNotifier.value = 10;
              },
            ),
          ],
        ),
      ),
    );
  }
}