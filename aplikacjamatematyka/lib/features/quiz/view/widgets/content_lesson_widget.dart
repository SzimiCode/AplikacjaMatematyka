import 'package:flutter/material.dart';

class ContentLessonWidget extends StatelessWidget {
  const ContentLessonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [

            _buildDotRow(),

            
            _buildRow(
              context,
              icon: Icons.camera_alt,
              asset: 'assets/images/knight.png',
              onTap: () {},
            ),

            _buildDotRow(),


            _buildRow(
              context,
              icon: Icons.menu_book,
              asset: 'assets/images/treasurechest.png',
              onTap: () {},
            ),

            _buildDotRow(),


            _buildRow(
              context,
              icon: Icons.emoji_events,
              asset: 'assets/images/dragon1.png',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context,
      {required IconData icon,
      required String asset,
      required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 85,
            height: 85,
            decoration: BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
        Image.asset(asset, height: 75, width: 75),
      ],
    );
  }

  Widget _buildDotRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (i) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
