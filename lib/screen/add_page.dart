import 'package:flutter/material.dart';
import 'package:todo_app/services/todo_service.dart';
import 'package:todo_app/utils/error_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage ({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage > createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState(){
    super.initState();
    final todo = widget.todo;
    if(todo != null){
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
          isEdit ? 'Todo List' : 'Add Todo',),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children:  [
           TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
           TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Text(isEdit ? 'Update' : 'Submit',),
          )
        ],
      ),
    );
  }

  Future<void> updateData() async {
    //Get the data from form
    final todo = widget.todo;
    final id = todo?['_id'];
    //submit updated data to the server
    final isSuccess = await TodoService.updateService(id, body);
    if(isSuccess) {
      showSuccessMessage(context, message: 'Updated Sucessfully');
    } else {
      showFailureMessage(context, message: 'Failed to Update');
    }
  }

  Future<void> submitData() async {
    //submit data to the server
    final isSuccess = await TodoService.createService(body);
    //show success or fail message based on status
      if(isSuccess) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage(context, message: 'Created Sucessfully');
    } else {
      showFailureMessage(context, message: 'Failed to Create');
    }
  }

  Map get body {
    // Get the data from form
    final title = titleController.text;
    final description = descriptionController.text;
    return {
      "title": title,
      "description": description,
    };
  }
}
