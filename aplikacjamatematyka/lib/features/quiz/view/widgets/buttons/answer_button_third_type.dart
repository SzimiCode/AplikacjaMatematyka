import 'package:flutter/material.dart';

class AnswerButtonThirdType extends StatelessWidget {
  const AnswerButtonThirdType({
    super.key,
    required this.text,
    required this.onTap,
    required this.isSelected,
    required this.isMatched,
    required this.isWrong,
  });

  final String text;
  final bool isSelected;
  final bool isMatched;
  final bool isWrong;
  final void Function() onTap;

  Color _getBackgroundColor() {
    if (isMatched) return Colors.grey;                         
    if (isWrong) return Colors.red;                            
    if (isSelected) return const Color.fromARGB(255, 120, 0, 160); 
    return const Color.fromARGB(255, 165, 12, 192);            
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isMatched ? null : onTap, 
      style: ElevatedButton.styleFrom(
        backgroundColor: _getBackgroundColor(),
        elevation: isSelected ? 10 : 2,
        padding: const EdgeInsets.symmetric(vertical: 18), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: isSelected
              ? const BorderSide(color: Colors.white, width: 2)
              : BorderSide.none,
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
