import 'package:http/http.dart' as http;
import 'dart:convert';

class ListItem {
  final String title;
  bool done;
  String id;

  ListItem(this.title, this.done, this.id);

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(json['title'], json['done'], json['id']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'done': done};
  }
}

const String ENDPOINT = 'https://todoapp-api.apps.k8s.gu.se';

/* class KeyFetcher {
  static Future<String> fetchKey() async {
    http.Response response = await http.get(Uri.parse('$ENDPOINT/register'));
    print(response.body);
    return response.body;
  }
} */

const String KEY = 'ab0304e3-fb5e-4adc-95ca-0c73a005ddbf';

class TodoGetter {
  static Future<List<ListItem>> fetchTodos(String key) async {
    var _key = key;

    http.Response response =
        await http.get(Uri.parse('$ENDPOINT/todos?key=$_key'));
    String body = response.body;

    var jsonResponse = jsonDecode(body);
    print(jsonResponse);

    var jsonMap =
        jsonResponse.map<ListItem>((todo) => ListItem.fromJson(todo)).toList();
    return jsonMap;
  }
}

class TodoPoster {
  Future<void> postTodo(ListItem item, String key) async {
    var _key = key;
    await http.post(Uri.parse('$ENDPOINT/todos?key=$_key'),
        body: jsonEncode(item.toJson()),
        headers: {'Content-Type': 'application/json'});
  }
}
