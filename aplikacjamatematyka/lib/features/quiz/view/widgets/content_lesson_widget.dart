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

            buildDotTrail(),


            _buildRow(
              context,
              icon: Icons.camera_alt,
              asset: 'assets/images/knight.png',
              onTap: () {},
            ),

            _buildDotContainerRightMine(),


            _buildRow(
              context,
              icon: Icons.menu_book,
              asset: 'assets/images/treasurechest.png',
              onTap: () {},
            ),

            _buildDotContainerLeft(),


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

  Widget _buildDotContainerRight() {
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

    Widget buildDotTrail() {
      
      final List<int> flexValues = [1, 3, 5, 7, 9];

      return SizedBox(
        width: 200,
        child: Column(
          children: flexValues.map((flex) {
            return Row(
              children: [
                Expanded(
                  flex: flex,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Expanded(
                  flex: 10 - flex,
                  child: const SizedBox(),
                ),
              ],
            );
          }).toList(),
        ),
      );
    }
   Widget _buildDotContainerLeft() {
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
