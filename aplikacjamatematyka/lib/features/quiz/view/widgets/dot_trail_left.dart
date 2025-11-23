import 'package:flutter/material.dart';

class DotTrailLeft extends StatelessWidget {
  const DotTrailLeft({super.key});

  @override
  Widget build(BuildContext context) {
    final positions = [
      const FractionalOffset(0.0, 1.0),
      const FractionalOffset(0.25, 0.70),
      const FractionalOffset(0.50, 0.50),
      const FractionalOffset(0.74, 0.18),
      const FractionalOffset(1.0, 0.0),
    ];

    return SizedBox(
      width: 90,
      height: 90,
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
