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
          children: [
             IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  //Tutaj będzie wyskakujace okno czy rezygnować
              },
             ),
             Container(
                clipBehavior: Clip.hardEdge,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                height: 80.0,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Positioned.fill(
                      child: LinearProgressIndicator(
                        value: 0.7,
                        color: Colors.blue.withAlpha(100),
                        backgroundColor: Colors.blue.withAlpha(50),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Hello world'),
                    )
                  ],
                ),
              ),
          ],
        )
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
