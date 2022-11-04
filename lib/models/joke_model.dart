import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const jokeCategories = <String>[
  'Any',
  'Animal',
  'Career',
  'Celebrity',
  'Dev',
  'Explicit',
  'Fashion',
  'Food',
  'History',
  'Money',
  'Movie',
  'Music',
  'Political',
  'Religion',
  'Science',
  'Sport',
  'Travel'
];

String _currentCategory = 'Any';

class Joke {
  final String id;
  final String joke;
  final String url;

  const Joke({
    required this.id,
    required this.joke,
    required this.url,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'],
      joke: json['value'],
      url: json['url'],
    );
  }
}

Future<Joke> getJoke() async {
  http.Response jokeResponse;
  try {
    if (_currentCategory == 'Any') {
      jokeResponse =
          await http.get(Uri.parse('https://api.chucknorris.io/jokes/random'));
    } else {
      jokeResponse = await http.get(Uri.parse(
          'https://api.chucknorris.io/jokes/random?category=${_currentCategory.toLowerCase()}'));
    }

    if (jokeResponse.statusCode == 200) {
      return Joke.fromJson(jsonDecode(jokeResponse.body));
    } else {
      throw Exception('Failed to load joke');
    }
  } catch (e) {
    throw Exception('No Connection');
  }
}

void setCategory(String category) {
  _currentCategory = category;
}

String getCategory() {
  return _currentCategory;
}

launchGivenUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw 'Could not launch $url';
  }
}
