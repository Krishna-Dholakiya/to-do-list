import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';


class ItemController extends GetxController{
  var item = <DocumentSnapshot>[].obs;
  final CollectionReference _items = FirebaseFirestore.instance.collection('items');

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    todoItems();
  }

  void todoItems() {
    _items.snapshots().listen((snapshot) {
      item.value = snapshot.docs;
    });
  }
  Future<void> addItem(String name, String description) async {
    if (name.isNotEmpty && description.isNotEmpty) {
      await _items.add({'name': name, 'description': description});
    }
  }

  Future<void> updateItem(String id, String name, String description) async {
    if (name.isNotEmpty && description.isNotEmpty) {
      await _items.doc(id).update({'name': name, 'description': description});
    }
  }

  Future<void> deleteItem(String id) async {
    await _items.doc(id).delete();
  }

}