import 'dart:convert';

import 'package:http/http.dart' as http;

searchJoke(String query) async {
  http.Response jokeResponse;

  jokeResponse = await http
      .get(Uri.parse('https://api.chucknorris.io/jokes/search?query=$query'));

  if (jokeResponse.statusCode == 200) {
    return jsonDecode(jokeResponse.body)['result'];
  } else {

    throw Exception('Failed to search for a joke');
  }
}
