import 'package:flutter/material.dart';

class AppBarQuizFirstTypeWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarQuizFirstTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      backgroundColor: const Color.fromARGB(255, 169, 143, 173),

      title: Padding(
        padding: const EdgeInsets.only(top: 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

          ],
        )
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
