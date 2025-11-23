import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/row_right.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/row_left.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/dot_trail_left.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/dot_trail_right.dart';

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
              onTap: () {},
            ),

            const DotTrailRight(),

            RowRight(
              icon: Icons.menu_book,
              asset: 'assets/images/treasurechest.png',
              onTap: () {},
            ),

            const DotTrailLeft(),

            RowLeft(
              icon: Icons.emoji_events,
              asset: 'assets/images/dragon1.png',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}