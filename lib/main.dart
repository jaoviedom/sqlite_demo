import 'package:flutter/material.dart';
import 'package:sqlite_demo/DB/db_helper.dart';
import 'package:sqlite_demo/UI/insert_item.dart';
import 'package:get/get.dart';

import 'Models/grocery.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SQLite example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'SQLite example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? selectedId;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de compras"),
      ),
      body: Center(
        child: FutureBuilder<List<Grocery>>(
          future: DBHelper.instance.getGroceries(),
          builder: (BuildContext context, AsyncSnapshot<List<Grocery>> snapshot) {
            if(!snapshot.hasData) {
              return const Center(child: Text("Cargando..."));
            }
            return snapshot.data!.isEmpty ?
              const Center(child: Text('No hay entradas'),)
              : ListView(
                children: snapshot.data!.map((grocery) {
                  return Center(
                    child: Card(
                      color: selectedId == grocery.id ? Colors.white70 : Colors.white,
                      child: ListTile(
                        title: Text(grocery.name),
                        onTap: (){
                          setState(() {
                            if (selectedId == null) {
                              textController.text = grocery.name;
                              selectedId = grocery.id;
                            } else {
                              textController.text = "";
                              selectedId = null;
                            }
                          });
                        },
                        trailing: GestureDetector(
                          child: const Icon(Icons.create_rounded),
                          onTap: () {
                            setState(() {
                              textController.text = grocery.name;
                              selectedId = grocery.id;
                            });
                            showDialog(
                                context: context,
                                builder: (context) => _buildEditAlertDialog(),
                            );
                          },
                        ),
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (context) => _buildDeleteAlertDialog(grocery),);
                        },
                      )
                    ),
                  );
                }).toList(),
              );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed:() {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const InsertItem(),))
              .then((newItem) {
                setState(() {
                  DBHelper.instance.getGroceries();
                });
                Get.snackbar("Agregado", "Elemento agregado correctamente!",
                    snackPosition: SnackPosition.BOTTOM);
          });
        },
        tooltip: 'Nuevo elemento',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _buildEditAlertDialog() {
    return AlertDialog(
      title: const Text('Editar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Modifique el nombre"),
          TextField(
            controller: textController,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            }),

        TextButton(
            child: const Text("Editar"),
            onPressed: () {
              if (selectedId != null) {
                DBHelper.instance.update(
                    Grocery(id: selectedId, name: textController.text)
                );
                setState(() {
                  DBHelper.instance.getGroceries();
                });
              }
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  Widget _buildDeleteAlertDialog(Grocery grocery) {
    return AlertDialog(
      title: const Text('Eliminar'),
      content: const Text('¿Está seguro de eliminar el elemento?'),
      actions: <Widget>[
        TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            }),

        TextButton(
            child: const Text("Si, eliminar"),
            onPressed: () {
              setState(() {
                DBHelper.instance.delete(grocery);
              });
              Navigator.of(context).pop();
            }),
      ],
    );
  }

}


