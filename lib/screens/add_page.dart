import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPage extends StatefulWidget {
  const AddPage({super.key, this.todo});
  final Map? todo;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Редагувати' : 'Додати',
          style: const TextStyle(fontFamily: 'Bebas_Neue_Cyrillic'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Назва'),
            style: const TextStyle(fontFamily: 'Bebas_Neue_Cyrillic'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Опис'),
            style: const TextStyle(fontFamily: 'Bebas_Neue_Cyrillic'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 10,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 87, 72, 72),
              foregroundColor: Colors.white,
            ),
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                isEdit ? 'Оновити' : 'Надіслати',
                style: const TextStyle(fontFamily: 'Bebas_Neue_Cyrillic'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      successMessage('Успішно редаговано');
    }
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    const url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      successMessage('Успішно створено');
    }
  }

  void successMessage(String message) {
    final snackBar = SnackBar(
        content: Text(
      message,
      style: const TextStyle(fontFamily: 'Bebas_Neue_Cyrillic'),
    ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
