import 'package:flutter/material.dart';

class RowRight extends StatelessWidget {
  final IconData icon;
  final String asset;
  final VoidCallback onTap;

  const RowRight({
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
        Image.asset(asset, height: 120, width: 120),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            width: 85,
            height: 85,
            decoration: const BoxDecoration(
              color: Colors.purple,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
