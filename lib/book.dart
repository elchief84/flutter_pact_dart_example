class Book {
  final String id;
  final String title;
  final String? description;

  const Book({required this.id, required this.title, this.description});

  Book.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'];

  Map<String, dynamic> toJson() {
    var res = {
      "id": id,
      "title": title,
    };

    if(description != null) {
      res["description"] = description!;
    }

    return res;
  }
}