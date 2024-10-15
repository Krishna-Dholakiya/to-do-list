import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_project/controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ItemController itemController = Get.put(ItemController());



  // Function to show dialog for adding a new item
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                itemController.addItem(_nameController.text, _descriptionController.text);

                Get.back();
                _descriptionController.clear();
                _nameController.clear();

              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Function to show dialog for updating an item
  void _showUpdateDialog(String id, String currentName, String currentDescription) {
    _nameController.text = currentName;
    _descriptionController.text = currentDescription;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
             onPressed: () {
               itemController.updateItem(id, _nameController.text, _descriptionController.text);
               Get.back();
             },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: Obx((){
          return ListView.builder(
            itemCount: itemController.item.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = itemController.item[index];
              return ListTile(
                title: Text(documentSnapshot['name']),
                subtitle: Text(documentSnapshot['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showUpdateDialog(documentSnapshot.id, documentSnapshot['name'], documentSnapshot['description']),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        itemController.deleteItem(documentSnapshot.id);
                      }
                    ),
                  ],
                ),
              );
            },
          );

          })


    );
  }
}