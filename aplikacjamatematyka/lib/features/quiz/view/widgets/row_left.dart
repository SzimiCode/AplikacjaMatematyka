import 'package:flutter/material.dart';

class RowLeft extends StatelessWidget {
  final IconData icon;
  final String asset;
  final VoidCallback onTap;

  const RowLeft({
    super.key,
    required this.icon,
    required this.asset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: Colors.white),
          ),
        ),
        SizedBox(width: 60),
        Image.asset(asset, height: 120, width: 120),
      ],
    );
  }
}
