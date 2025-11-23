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

            buildDotTrailLeft(),
            
            SizedBox(height: 10),

            _buildRowLeft(
              context,
              icon: Icons.camera_alt,
              asset: 'assets/images/knight.png',
              onTap: () {},
            ),

             buildDotTrailRight(),

            SizedBox(height: 10),

            _buildRowRight(
              context,
              icon: Icons.menu_book,
              asset: 'assets/images/treasurechest.png',
              onTap: () {},
            ),

            SizedBox(height: 10),

            buildDotTrailLeft(),

            SizedBox(height: 10),


            _buildRowLeft(
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

  Widget _buildRowLeft(BuildContext context,
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
        Image.asset(asset, height: 120, width: 120),
      ],
    );
  }
  Widget _buildRowRight(BuildContext context,
      {required IconData icon,
      required String asset,
      required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Image.asset(asset, height: 120, width: 120),
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
        
      ],
    );
  }
      Widget buildDotTrailRight() {
      final positions = [
        const FractionalOffset(0.0, 0.0),
        const FractionalOffset(0.20, 0.30),
        const FractionalOffset(0.50, 0.50),
        const FractionalOffset(0.70, 0.80),
        const FractionalOffset(1.0, 1.0),
      ];

      return Container(
        child: SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            children: positions.map((pos) {
              return Align(
                alignment: pos,
                child: Container(
                  width: 19,
                  height: 19,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
    Widget buildDotTrailLeft() {
      final positions = [
        const FractionalOffset(0.0, 1.0),
        const FractionalOffset(0.25, 0.70),
        const FractionalOffset(0.50, 0.50),
        const FractionalOffset(0.74, 0.18),
        const FractionalOffset(1.0, 0.0),
      ];

      return Container(
        child: SizedBox(
          width: 120,
          height: 120,
          child: Stack(
            children: positions.map((pos) {
              return Align(
                alignment: pos,
                child: Container(
                  width: 19,
                  height: 19,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
}
