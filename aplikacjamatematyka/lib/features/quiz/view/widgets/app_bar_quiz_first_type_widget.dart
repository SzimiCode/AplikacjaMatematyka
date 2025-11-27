import 'package:flutter/material.dart';

class AppBarQuizFirstTypeWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarQuizFirstTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,

      title: Padding(
        padding: const EdgeInsets.only(top: 22),
        child: Row(
          children: [
             IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  //Tutaj będzie wyskakujace okno czy rezygnować
              },
             ),
      
          ],
        )
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
