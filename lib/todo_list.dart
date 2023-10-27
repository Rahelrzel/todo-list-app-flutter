import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  TextEditingController textFieldController = TextEditingController();
  List<Map<String, dynamic>> todoItems = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (picked != null) {
      setState(() {
        String text = textFieldController.text;
        if (text.isNotEmpty) {
          final newItem = {
            'text': text,
            'date': picked,
            'isChecked': false,
          };
          todoItems.add(newItem);
          textFieldController.clear();
        }
      });
    }
  }

  void _handleCheckboxChange(int index, bool newValue) {
    setState(() {
      todoItems[index]['isChecked'] = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: const [
              Tab(
                text: "Upcoming",
              ),
              Tab(
                text: "completed",
              ),
              Tab(
                text: "overdue",
              ),
            ],
            //unselectedLabelColor: const Color.fromARGB(255, 190, 188, 188),
            //labelColor: Colors.white,
            splashBorderRadius: BorderRadius.circular(30),
            indicator: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.transparent, width: 0.0),
              ),
            ),
          ),
          title: const Text(
            'Habit Manager',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      for (int index = 0; index < todoItems.length; index++)
                        Column(
                          children: [
                            const SizedBox(height: 8.0),
                            TodoItemWidget(
                              text: todoItems[index]['text'] ?? '',
                              date: todoItems[index]['date'],
                              isChecked: todoItems[index]['isChecked'] ?? false,
                              onChanged: (bool? newValue) {
                                _handleCheckboxChange(index, newValue ?? false);
                              },
                            ),
                            const SizedBox(height: 8.0),
                          ],
                        ),
                    ],
                  ),
                  Container(
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18, bottom: 1),
                            child: TextField(
                              controller: textFieldController,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          icon: const Icon(
                            Icons.add_rounded,
                            color: Color.fromARGB(255, 8, 172, 95),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CompletedTab(todoItems: todoItems),
            OverdoTab(todoItems: todoItems),
          ],
        ),
      ),
    );
  }
}

class CompletedTab extends StatelessWidget {
  final List<Map<String, dynamic>> todoItems;

  const CompletedTab({super.key, required this.todoItems});

  @override
  Widget build(BuildContext context) {
    List<Widget> completedTaskWidgets = todoItems.where((item) {
      bool isChecked = item['isChecked'];
      return isChecked;
    }).map((item) {
      return TodoItemWidget(
        text: item['text'] ?? '',
        date: item['date'],
        isChecked: true,
        onChanged: (bool? newValue) {},
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: completedTaskWidgets,
      ),
    );
  }
}

class OverdoTab extends StatelessWidget {
  final List<Map<String, dynamic>> todoItems;

  const OverdoTab({super.key, required this.todoItems});

  @override
  Widget build(BuildContext context) {
    List<Widget> overdueTaskWidgets = todoItems.where((item) {
      bool isChecked = item['isChecked'];
      DateTime? date = item['date'];

      if (date != null && !isChecked) {
        return date.isBefore(DateTime.now());
      }

      return false;
    }).map((item) {
      return TodoItemWidget(
        text: item['text'] ?? '',
        date: item['date'],
        isChecked: item['isChecked'] ?? false,
        onChanged: (bool? newValue) {},
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: overdueTaskWidgets,
      ),
    );
  }
}

class TodoItemWidget extends StatelessWidget {
  final String text;
  final DateTime? date;
  final bool isChecked;
  final void Function(bool?) onChanged;

  const TodoItemWidget({
    super.key,
    required this.text,
    this.date,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              CheckboxListTile(
                title: Text(
                  text,
                ),
                value: isChecked,
                onChanged: onChanged,
                controlAffinity: ListTileControlAffinity.leading,
              ),
              if (date != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        ' Due on: ${DateFormat.yMMMMd().format(date!)}',
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
