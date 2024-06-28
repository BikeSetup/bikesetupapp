import 'package:bikesetupapp/alert_dialogs/todo_list_alert_dialogs.dart';
import 'package:bikesetupapp/database_service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ToDoList extends StatefulWidget {
  final User user;
  final String uBikeID;
  final String bikeName;
  const ToDoList(
      {super.key,
      required this.user,
      required this.uBikeID,
      required this.bikeName});

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        widget.bikeName,
        style: Theme.of(context).textTheme.titleLarge,
      )),
      body: StreamBuilder(
        stream: DatabaseService(widget.user.uid).getTodoList(widget.uBikeID),
        builder: ((context, AsyncSnapshot snapshot) {
          if (ConnectionState.waiting == snapshot.connectionState) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error'));
          } else {
            if (snapshot.data.docs.isEmpty) {
              return const Center(child: Text('You have nothing to do!'));
            } else {
              return ListView(
                shrinkWrap: true,
                children: [
                  ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(
                        'Todo',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      trailing: Icon(Icons.list,
                          color: Theme.of(context).textTheme.labelLarge!.color),
                      children: [
                        SizedBox(
                            child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot data = snapshot.data.docs[index];
                            return Visibility(
                                visible: !data['done'],
                                child: Card(
                                    child: ListTile(
                                  onTap: () {
                                    TodoAlerts.editTodo(
                                        context,
                                        widget.uBikeID,
                                        data.id,
                                        widget.user,
                                        data['task_name'],
                                        data['task_description'],
                                        data['Part'],
                                        data['done']);
                                  },
                                  title: Text(
                                    data['task_name'],
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  subtitle: Text(
                                    data['task_description'],
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  trailing: Checkbox(
                                    activeColor: Theme.of(context).primaryColor,
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .color!),
                                    value: data['done'],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        try {
                                          DatabaseService(widget.user.uid)
                                            .updateTodoList(
                                                widget.uBikeID, data.id, value!);
                                        } catch (e) {
                                          TodoAlerts.generalError(context, 'Error updating todo');
                                        }
                                        
                                      });
                                    },
                                  ),
                                )));
                          },
                        )),
                      ]),
                  ExpansionTile(
                    title: Text(
                      'Done',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    trailing: Icon(Icons.done_all,
                        color: Theme.of(context).textTheme.labelLarge!.color),
                    children: [
                      SizedBox(
                          child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data = snapshot.data.docs[index];
                          return Visibility(
                              visible: data['done'],
                              child: Card(
                                  child: ListTile(
                                onTap: () {
                                  TodoAlerts.editTodo(
                                      context,
                                      widget.uBikeID,
                                      data.id,
                                      widget.user,
                                      data['task_name'],
                                      data['task_description'],
                                      data['Part'],
                                      data['done']);
                                },
                                title: Text(
                                  data['task_name'],
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                                subtitle: Text(
                                  data['task_description'],
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                trailing: Checkbox(
                                  activeColor: Theme.of(context).primaryColor,
                                  side: BorderSide(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .color!),
                                  value: data['done'],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      try {
                                        DatabaseService(widget.user.uid)
                                            .updateTodoList(
                                                widget.uBikeID, data.id, value!);
                                      } catch (e) {
                                        TodoAlerts.generalError(context, 'Error updating todo');
                                      }
                                    });
                                  },
                                ),
                              )));
                        },
                      )),
                    ],
                  )
                ],
              );
            }
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TodoAlerts.newTodo(context, widget.uBikeID, widget.user);
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
