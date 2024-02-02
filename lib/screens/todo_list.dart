import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:load_add_edit/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Список',
          style: TextStyle(fontFamily: 'Bebas_Neue_Cyrillic'),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'] as String;
              return ListTile(
                title: Text(
                  item['title'],
                  style: const TextStyle(fontFamily: 'Bebas_Neue_Cyrillic'),
                ),
                subtitle: Text(
                  item['description'],
                  style: const TextStyle(fontFamily: 'Bebas_Neue_Cyrillic'),
                ),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == 'edit') {
                      navigateToEditPage(item);
                    } else if (value == 'delete') {
                      deleteById(id);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text(
                          'Редагувати',
                          style: TextStyle(fontFamily: 'Bebas_Neue_Cyrillic'),
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Видалити',
                          style: TextStyle(fontFamily: 'Bebas_Neue_Cyrillic'),
                        ),
                      ),
                    ];
                  },
                ),
              );
            },
          ),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text(
          'Додати',
          style: TextStyle(fontFamily: 'Bebas_Neue_Cyrillic'),
        ),
      ),
    );
  }

  void navigateToEditPage(Map item) {
    final route = MaterialPageRoute(
      builder: (context) => AddPage(todo: item),
    );
    Navigator.push(context, route);
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (context) => const AddPage(),
    );
    Navigator.push(context, route);
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      final filter = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filter;
      });
    }
  }

  Future<void> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
