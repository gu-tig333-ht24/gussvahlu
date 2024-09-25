import 'package:flutter/material.dart';

Widget item(String input, bool isDone) {
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
