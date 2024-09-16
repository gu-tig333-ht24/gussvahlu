import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIG333 TODO',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'TIG333 TODO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class ListItem {
  final String title;
  final bool isDone;

  ListItem(this.title, this.isDone);
}

class _MyHomePageState extends State<MyHomePage> {
  List<ListItem> todoList = [
    ListItem('Write a book', false),
    ListItem('Do homework', false),
    ListItem('Tidy room', true),
    ListItem('Watch TV', false),
    ListItem('Nap', false),
    ListItem('Shop groceries', false),
    ListItem('Have fun', false),
    ListItem('Meditate', false)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text(widget.title),
          centerTitle: true,
          toolbarHeight: 40),
      body: ListView(
          children: todoList.map((e) => _item(e.title, e.isDone)).toList()),
      floatingActionButton: FloatingActionButton(
          onPressed: null,
          tooltip: 'Increment',
          backgroundColor: Colors.grey,
          shape: CircleBorder(side: BorderSide(color: Colors.grey, width: 2)),
          elevation: 4,
          highlightElevation: 4,
          child: const Icon(Icons.add, color: Colors.white, size: 50)),
    );
  }

  Widget _item(String input, bool isDone) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2)),
              child: isDone
                  ? Icon(
                      Icons.done,
                      color: Colors.black,
                      size: 15,
                    )
                  : null,
            )),
        Expanded(
          child: Text(input,
              style: TextStyle(
                fontSize: 28,
                decoration:
                    isDone ? TextDecoration.lineThrough : TextDecoration.none,
                decorationColor: Colors.black,
              )),
        ),
        Padding(
            padding: EdgeInsets.all(20),
            child: Icon(Icons.close, color: Colors.black, size: 30))
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
