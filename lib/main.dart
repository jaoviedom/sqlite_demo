import 'package:flutter/material.dart';
import 'package:sqlite_demo/DB/db_helper.dart';
import 'package:sqlite_demo/UI/insert_item.dart';

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
    return MaterialApp(
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
                        onLongPress: () {
                          setState(() {
                            DBHelper.instance.delete(grocery);
                          });
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
          });
        },
        /*onPressed: () async {
          selectedId != null ?
            await DBHelper.instance.update(
              Grocery(id: selectedId, name: textController.text)
            ) :
            await DBHelper.instance.add(
              Grocery(name: textController.text)
          );
          setState(() {
            textController.clear();
            selectedId = null;
          });
        },*/
        tooltip: 'Nuevo elemento',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


