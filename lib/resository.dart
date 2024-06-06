import 'dart:convert';

import 'book.dart';
import 'package:http/http.dart' as http;

class Repository {

  static const String base_url = 'https://5bb7-2-237-16-105.ngrok-free.app'; // http://localhost:3000

  static Future<List<Book>?> books() async {
    var response = await http.get(Uri.parse('$base_url/books'));

    if(response.statusCode == 200) {
      final data = (json.decode(response.body) as Map<String, dynamic>)['data'];
      List<Book>? list = List<Book>.from(data.map((item) => Book.fromJson(item)));
      return list;
    }
    return null;
  }

  static Future<Book?> book({required String title, String? description}) async {
    var params = {'title': title};
    if(description != null) { params['description'] = description;}

    var response = await http.post(Uri.parse('$base_url/book'), body: params);

    if(response.statusCode == 200) {
      return Book.fromJson(json.decode(response.body));
    }
    return null;
  }
}