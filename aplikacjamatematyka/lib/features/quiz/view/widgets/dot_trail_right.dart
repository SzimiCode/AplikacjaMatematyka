import 'package:flutter/material.dart';

class DotTrailRight extends StatelessWidget {
  const DotTrailRight({super.key});

  @override
  Widget build(BuildContext context) {
    final positions = [
      const FractionalOffset(0.0, 0.0),
      const FractionalOffset(0.20, 0.30),
      const FractionalOffset(0.50, 0.50),
      const FractionalOffset(0.70, 0.80),
      const FractionalOffset(1.0, 1.0),
    ];

    return SizedBox(
      width: 110,
      height: 110,
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
    );
  }
}
