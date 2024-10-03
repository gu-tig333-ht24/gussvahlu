import 'package:http/http.dart' as http;
import 'dart:convert';

class ListItem {
  final String title;
  bool done;
  String id;

  ListItem(this.title, this.done, this.id);

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      json['title'],
      json['done'] is bool
          ? json['done']
          : json['done'].toString().toLowerCase() == 'true',
      json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'done': done};
  }
}

const String ENDPOINT = 'https://todoapp-api.apps.k8s.gu.se';

class KeyFetcher {
  static Future<String> fetchKey() async {
    http.Response response = await http.get(Uri.parse('$ENDPOINT/register'));
    /* print(response.body); */ // Debugging
    return response.body;
  }
}

const String KEY = '6b2b9d69-09c4-4dd7-a9ba-02af1c923768';

// Hade kunnat gömma nyckeln med en .env-fil, men anser inte riktigt att det är nödvändigt just för denna inlämningen. /lucas

class TodoGetter {
  static Future<List<ListItem>> fetchTodos(String key) async {
    var _key = key;

    http.Response response =
        await http.get(Uri.parse('$ENDPOINT/todos?key=$_key'));
    String body = response.body;

    var jsonResponse = jsonDecode(body);
    /* print(jsonResponse); */ // Debugging

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

class TodoUpdate {
  Future<void> doneTodo(ListItem item, String key) async {
    var _key = key;

    await http.put(Uri.parse('$ENDPOINT/todos/${item.id}?key=$_key'),
        headers: {'Content-Type': 'application/json'},
        body:
            jsonEncode({'title': item.title, 'done': item.done = !item.done}));
  }

  Future<void> deleteTodo(ListItem item, String key) async {
    var _key = key;

    await http.delete(Uri.parse('$ENDPOINT/todos/${item.id}?key=$_key'));
  }
}
