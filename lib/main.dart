import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './api.dart';

void main() {
  MyState state = MyState();
  runApp(ChangeNotifierProvider(
    create: (context) => state,
    child: MyApp(),
  ));
}

AppBar buildAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: Colors.grey,
    title: Text(title),
    centerTitle: true,
    toolbarHeight: 40,
    iconTheme: IconThemeData(color: Colors.black),
    actions: [
      IconButton(
        icon: Icon(Icons.more_vert, color: Colors.black),
        onPressed: () {
          _showFilterDialog(context);
        },
      ),
    ],
  );
}

void _showFilterDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('Filter Items'),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () {
              context.read<MyState>().setFilter('All');
              Navigator.pop(context);
            },
            child: Text('All'),
          ),
          SimpleDialogOption(
            onPressed: () {
              context.read<MyState>().setFilter('Done');
              Navigator.pop(context);
            },
            child: Text('Done'),
          ),
          SimpleDialogOption(
            onPressed: () {
              context.read<MyState>().setFilter('Undone');
              Navigator.pop(context);
            },
            child: Text('Undone'),
          ),
        ],
      );
    },
  );
}

class MyState extends ChangeNotifier {
  MyState() {
    fetchTodos();
    /* keyFetcher(); */
  }

  List<ListItem> _todoList = [];

  List<ListItem> get todoList {
    if (_filter == 'All') {
      return _todoList;
    } else if (_filter == 'Done') {
      return _todoList.where((item) => item.done).toList();
    } else if (_filter == 'Undone') {
      return _todoList.where((item) => !item.done).toList();
    }
    return _todoList;
  }

  var _filter = 'All';
  String get filter => _filter;

  var _key = KEY;
  String get key => _key;

  void fetchTodos() async {
    _todoList = await TodoGetter.fetchTodos(KEY);
    notifyListeners();
  }

  void setFilter(String filter) {
    if (filter == 'Done') {
      _filter = 'Done';
    } else if (filter == 'Undone') {
      _filter = 'Undone';
    } else {
      _filter = 'All';
    }
    notifyListeners();
  }

  void addListItem(ListItem item) async {
    await TodoPoster().postTodo(item, KEY);
    fetchTodos();
  }

  void keyFetcher() async {
    _key = await KeyFetcher.fetchKey();
    notifyListeners();
  }

  void checkboxItem(int index) async {
    await TodoUpdate().doneTodo(_todoList[index], KEY);
    notifyListeners();
  }

  void deleteItem(int index) async {
    List<ListItem> filteredList;
    if (_filter == 'Done') {
      filteredList = _todoList.where((item) => item.done).toList();
    } else if (_filter == 'Undone') {
      filteredList = _todoList.where((item) => !item.done).toList();
    } else {
      filteredList = _todoList;
    }

    await TodoUpdate().deleteTodo(filteredList[index], KEY);
    fetchTodos();
  }
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
      appBar: buildAppBar(context, 'TIG333 TODO'),
      body: ListView.builder(
        itemCount: stateList.length,
        itemBuilder: (context, index) {
          return items(index, context);
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

  Widget items(int index, BuildContext context) {
    var stateList = context.watch<MyState>().todoList;
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: GestureDetector(
              onTap: () {
                context.read<MyState>().checkboxItem(index);
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2)),
                child: stateList[index].done
                    ? Icon(
                        Icons.done,
                        color: Colors.black,
                        size: 15,
                      )
                    : null,
              )),
        ),
        Expanded(
          child: Text(stateList[index].title,
              style: TextStyle(
                fontSize: 28,
                decoration: stateList[index].done
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: Colors.black,
              )),
        ),
        Padding(
            padding: EdgeInsets.all(20),
            child: GestureDetector(
                onTap: () {
                  context.read<MyState>().deleteItem(index);
                  context.read<MyState>().fetchTodos();
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
      appBar: buildAppBar(context, 'TIG333 TODO'),
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
                      var itemtitle = textEditingController.text;
                      ListItem item = ListItem(itemtitle, false, '');
                      context.read<MyState>().addListItem(item);
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
