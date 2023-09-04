import 'package:flutter/material.dart';
import 'package:todo_app/screen/add_page.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/widget/todo_card.dart';
import '../utils/error_helper.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = false;
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
        title: const Text('Todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text('No Todo Item Avalaible',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'];
                return TodoCard(
                  index: index,
                  item: item,
                  deleteById: deleteById,
                  navigateEdit: navigateToEditPage,
                );
              }
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
          label: const Text('Add Todo'),
      ),
    );
  }

  Future<void> navigateToAddPage() async{
    final route = MaterialPageRoute(
        builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
   await Navigator.push(context, route);
   setState(() {
     isLoading = true;
   });
   fetchTodo();
  }

  Future<void> deleteById(String id) async {
    //Delete the item
    final isSuccess = await TodoService.deleteService(id);
    if (isSuccess) {
      //Remove item from the list
     final filtered = items.where((element) => element['_id'] != id).toList();
     setState(() {
       items = filtered;
     });
    } else {
      // Show error

    }
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchService();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showFailureMessage(context, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }
}
