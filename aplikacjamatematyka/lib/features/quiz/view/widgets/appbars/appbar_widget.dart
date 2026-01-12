import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/theme/app_pallete.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/buttons/topic_picker_button.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/category_model.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onClassToggle;
  final Function(CategoryModel)? onCategorySelected;
  final int totalPoints;

  const AppbarWidget({
    super.key,
    required this.onClassToggle,
    this.onCategorySelected,
    this.totalPoints = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 165, 12, 192),
      title: Padding(
        padding: const EdgeInsets.only(top: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder(
              valueListenable: selectedClassNotifier,
              builder: (context, selectedClass, child) {
                return ElevatedButton(
                  onPressed: onClassToggle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 222, 133, 238),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 11,
                    ),
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(selectedClass?.className ?? "Klasy 1–4"),
                );
              },
            ),
            SizedBox(width: 8),
            TopicPickerButton(
              onCategorySelected: onCategorySelected,
            ),
            SizedBox(width: 6),
            Container(
              width: 90,
              height: 43,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 222, 133, 238),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$totalPoints',
                    style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 3),
                  Image.asset(
                    'assets/images/fire1.png',
                    height: 30,
                    width: 35,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}