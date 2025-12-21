import 'package:flutter/material.dart';
import 'package:aplikacjamatematyka/core/data/notifiers.dart';
import 'package:aplikacjamatematyka/features/quiz/model/category_model.dart';

class TopicPickerButton extends StatelessWidget {
  final Function(CategoryModel)? onCategorySelected;

  const TopicPickerButton({
    super.key,
    this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedCategoryNotifier,
      builder: (context, selectedCategory, child) {
        return ElevatedButton(
          onPressed: () {
            _showCategoryPicker(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 222, 133, 238),
            foregroundColor: Colors.white,
            textStyle: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            selectedCategory?.categoryName ?? "Wybierz temat"
          ),
        );
      },
    );
  }

  void _showCategoryPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return ValueListenableBuilder(
          valueListenable: categoriesNotifier,
          builder: (context, categories, child) {
            return Container(
              padding: EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  
                  return Card(
                    child: ListTile(
                      title: Text(
                        category.categoryName,
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        selectedCategoryNotifier.value = category;
                        if (onCategorySelected != null) {
                          onCategorySelected!(category);
                        }
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}