import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/favourite_storage.dart';
import 'models/joke_model.dart';

class JokeScreen extends StatefulWidget {
  const JokeScreen({super.key});


  @override
  State<JokeScreen> createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  late Future<Joke> _futureJoke;
  String _url = '';
  String _id = '';
  String _joke = '';

  Offset _offset = Offset.zero;

  // var to control favourite color
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _futureJoke = getJoke();
  }

  void _updateJoke() {
    setState(() {
      _futureJoke = getJoke();
      _isPressed = false;
    });
  }

  void _updateCategory(String category) {
    setState(() {
      _isPressed = false;
      setCategory(category);
      _futureJoke = getJoke();
    });
  }

  @override
  Widget build(BuildContext context) {
    // var to keep track of current favourites
    final favouritesList = context.watch<Favourites>();

    // var to keep screen height
    double sH = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jokes by Chuck Norris'),
        actions: [
          // leading is dropdown menu to choose joke category
          DecoratedBox(
            decoration: BoxDecoration(
                //background color of dropdown button
                color: Colors.white,
                //border of dropdown button
                border: Border.all(color: Colors.blue, width: 3),
                boxShadow: const <BoxShadow>[
                  //apply shadow on Dropdown button
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.57), blurRadius: 5),
                ]),
            child: Padding(
              padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
              child: DropdownButton<String>(
                value: getCategory(),
                icon: const Icon(
                  Icons.filter_alt,
                  color: Colors.lightBlue,
                ),
                elevation: 16,
                alignment: AlignmentDirectional.center,
                style: const TextStyle(color: Colors.blue),
                underline: Container(),
                onChanged: (String? value) {
                  setState(() {
                    _updateCategory(value!);
                  });
                },
                items: jokeCategories
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        // SafeArea to make sure the user can see the whole app without obstructions
        child: Center(
          child: SafeArea(
            top: false,
            bottom: false,
            minimum: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: 'Open in external browser',
                  icon: const Icon(
                    CupertinoIcons.globe,
                    color: Colors.lightBlue,
                  ),
                  onPressed: () {
                    if (_url != '') {
                      launchGivenUrl(_url);
                    }
                  },
                  alignment: Alignment.bottomLeft,
                ),
                SizedBox(
                  height: sH * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48.0)),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.0)),
                      FutureBuilder<Joke>(
                        future: _futureJoke,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            _url = snapshot.data!.url;
                            _id = snapshot.data!.id;
                            _joke = snapshot.data!.joke;
                            return Text(
                              _joke,
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            );
                          } else if (snapshot.hasError) {
                            return Column(
                              children: [
                                const Icon(Icons.wifi_off),
                                Text(
                                  'No Connection',
                                  style: Theme.of(context).textTheme.headline5,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          }
                          return const CircularProgressIndicator();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Column(
                          children: [
                            IconButton(
                              tooltip:
                                  'Save the current joke to your favourite list',
                              icon: Icon(
                                Icons.favorite,
                                color: _isPressed ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                if (_id != '') {
                                  !favouritesList.containsKey(_id)
                                      ? favouritesList.add(_id, _joke)
                                      : favouritesList.remove(_id);
                                  _isPressed = !_isPressed;
                                }
                              },
                              alignment: Alignment.bottomRight,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateJoke,
        tooltip: 'Populates Next Joke',
        child: const Icon(Icons.forward),
      ),
    );
  }
}
