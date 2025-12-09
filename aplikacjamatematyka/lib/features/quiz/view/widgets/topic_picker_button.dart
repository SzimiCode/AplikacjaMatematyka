import 'package:flutter/material.dart';

class TopicPickerButton extends StatefulWidget {
  @override
  _TopicPickerButtonState createState() => _TopicPickerButtonState();
}

class _TopicPickerButtonState extends State<TopicPickerButton> {
  String? selectedTopic;

  // lista dla mnie, zmien mateusza na backend
  final List<String> topics = [
    "Liczby naturalne",
    "Ułamki zwykłe",
    "Mnożenie",
  ];

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          isScrollControlled: true,
          builder: (context) {
            return Container(
              padding: EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.6,
              child: ListView.builder(
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(topics[index], style: TextStyle(fontSize: 18)),
                      onTap: () {
                        setState(() {
                          selectedTopic = topics[index];
                        });
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

      
      child: Text(selectedTopic ?? "Wybierz temat"),
    );
  }
}
