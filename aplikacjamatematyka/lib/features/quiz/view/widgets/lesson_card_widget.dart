import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final int number;
  final String title;
  final Color color;
  final VoidCallback? onTap;
  final int flameCounter;

  const LessonCard({
    super.key,
    required this.number,
    required this.title,
    required this.color,
    this.onTap,
    required this.flameCounter,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20), 
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                number.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 4),
    
            const SizedBox(width: 4),
            
            
            Row(
              children: List.generate(4, (index) {
                bool isActive = index < flameCounter;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Image.asset(
                    isActive ? 'assets/images/fire1.png' : 'assets/images/fire2.png',
                    height: 17,
                    width: 17,
                  ),
                );
              }
              ),
            ),
          ],
      ),
      ),
    );
  }
}
