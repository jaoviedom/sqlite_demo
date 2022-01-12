import 'package:flutter/material.dart';
import 'package:sqlite_demo/DB/db_helper.dart';
import 'package:sqlite_demo/Models/grocery.dart';
import 'package:get/get.dart';

class InsertItem extends StatefulWidget {
  const InsertItem({Key? key}) : super(key: key);

  @override
  _InsertItemState createState() => _InsertItemState();
}

class _InsertItemState extends State<InsertItem> {

  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingresar producto"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                filled: true,
                labelText: "Ingrese el nuevo elemento",
                suffix: GestureDetector(
                  child: const Icon(Icons.close),
                  onTap: () {
                    textController.clear();
                  },
                ),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: (){
                if(textController.text.isNotEmpty) {
                  Grocery grocery = Grocery(name: textController.text);
                  DBHelper.instance.add(grocery);
                  Navigator.pop(context, grocery.name);
                }
              },
              child: const Text("Guardar"),
          )
        ],
      ),
    );
  }
}
