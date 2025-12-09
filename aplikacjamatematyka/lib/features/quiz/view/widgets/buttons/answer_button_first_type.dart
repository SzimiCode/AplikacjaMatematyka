import 'package:flutter/material.dart';

class AnswerButtonFirstType extends StatelessWidget {
  const AnswerButtonFirstType({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected,

  });

  final String text;
  final bool isSelected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? const Color.fromARGB(255, 120, 0, 160)  
            : const Color.fromARGB(255, 165, 12, 192),
        elevation: isSelected ? 10 : 2,    
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? const BorderSide(color: Colors.white, width: 2) 
              : BorderSide.none,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
    );
  }
}
