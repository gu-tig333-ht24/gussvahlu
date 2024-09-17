import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  MyState state = MyState();

  runApp(ChangeNotifierProvider(
    create: (context) => state,
    child: MyApp(),
  ));
}

AppBar buildAppBar(String title) {
  return AppBar(
    backgroundColor: Colors.grey,
    title: Text(title),
    centerTitle: true,
    toolbarHeight: 40,
  );
}

class MyState extends ChangeNotifier {
  List<ListItem> _todoList = [
    ListItem('Write a book', false),
    ListItem('Do homework', false),
    ListItem('Tidy room', true),
    ListItem('Watch TV', false),
    ListItem('Nap', false),
    ListItem('Shop groceries', false),
    ListItem('Have fun', false),
    ListItem('Meditate', false)
  ];

  List<ListItem> get todoList => _todoList;

  void addItem(String title) {
    _todoList.add(ListItem(title, false));
    notifyListeners();
  }

  void removeItem(int index) {
    _todoList.removeAt(index);
    notifyListeners();
  }

  void finishItem(int index) {
    _todoList[index].isDone = !_todoList[index].isDone;
    notifyListeners();
  }
}

class ListItem {
  final String title;
  bool isDone;

  ListItem(this.title, this.isDone);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIG333 TODO',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var stateList = context.watch<MyState>().todoList;
    return Scaffold(
      appBar: buildAppBar('TIG333 TODO'),
      body: ListView.builder(
        itemCount: stateList.length,
        itemBuilder: (context, index) {
          return _item(index, context);
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddItemPage()),
            );
          },
          backgroundColor: Colors.grey,
          shape: CircleBorder(side: BorderSide(color: Colors.grey, width: 2)),
          elevation: 4,
          highlightElevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 50)),
    );
  }

  Widget _item(int index, BuildContext context) {
    var stateList = context.watch<MyState>().todoList;
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
            padding: EdgeInsets.all(20),
            child: GestureDetector(
                onTap: () {
                  context.read<MyState>().finishItem(index);
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      border: Border.all(color: Colors.black, width: 2)),
                  child: stateList[index].isDone
                      ? Icon(
                          Icons.done,
                          color: Colors.black,
                          size: 15,
                        )
                      : null,
                ))),
        Expanded(
          child: Text(stateList[index].title,
              style: TextStyle(
                fontSize: 28,
                decoration: stateList[index].isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: Colors.black,
              )),
        ),
        Padding(
            padding: EdgeInsets.all(20),
            child: GestureDetector(
                onTap: () {
                  context.read<MyState>().removeItem(index);
                },
                child: Icon(Icons.close, color: Colors.black, size: 30))),
      ]),
      Container(
          decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 0.7,
          ),
        ),
      ))
    ]);
  }
}

class AddItemPage extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar('TIG333 TODO'),
      body: Container(
          alignment: Alignment.topCenter,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'What are you going to do?',
                  )),
            ),
            Padding(
                padding: EdgeInsets.only(top: 40),
                child: FloatingActionButton.extended(
                    label: Text('ADD',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    onPressed: () {
                      context
                          .read<MyState>()
                          .addItem(textEditingController.text);
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.white,
                    elevation: 0,
                    highlightElevation: 3,
                    hoverColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    icon: Icon(Icons.add, color: Colors.black, size: 30))),
          ])),
    );
  }
}
