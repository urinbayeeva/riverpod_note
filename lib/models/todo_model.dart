import 'dart:convert';

List<ToDo> toDoFromJson(String str) =>
    List<ToDo>.from(json.decode(str).map((x) => ToDo.fromJson(x)));

String toDoToJson(List<ToDo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ToDo {
  final String title;
  final String description;
  final String id;

  ToDo({
    required this.title,
    required this.description,
    required this.id,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) => ToDo(
        title: json["title"],
        description: json["description"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "id": id,
      };
}
