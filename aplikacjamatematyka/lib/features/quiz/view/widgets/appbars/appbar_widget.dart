import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/theme/app_pallete.dart';
import 'package:aplikacjamatematyka/features/quiz/view/widgets/buttons/topic_picker_button.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

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
            ElevatedButton(
              onPressed: () {},
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
              //Do podstawienia z bazy danych które
              child: Text("Klasy 1–4"),
            ),
            SizedBox(width: 8),
          TopicPickerButton(),
            
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
                      '5',
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
