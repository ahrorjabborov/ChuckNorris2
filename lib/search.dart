import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/favourite_storage.dart';
import 'models/search_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});


  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _controller;
  List _jokeList = [];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _searchJoke(String query) {
    searchJoke(query).then((jokeListMap) {
      _jokeList = jokeListMap;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: 10)),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Query',
              ),
              onSubmitted: (String value) async {
                _searchJoke(value);
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _jokeList.length,
                itemBuilder: (BuildContext context, int index) =>
                    SearchItemTile(
                        _jokeList[index]['id'], _jokeList[index]['value']),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchItemTile extends StatefulWidget {
  final String itemID;
  final String item;

  const SearchItemTile(this.itemID, this.item, {super.key});

  @override
  State<SearchItemTile> createState() => _SearchItemTileState();
}

class _SearchItemTileState extends State<SearchItemTile> {
  bool _isPressed = false;

  void isPressed() {
    setState(() {
      _isPressed = !_isPressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favouritesList = context.watch<Favourites>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(widget.item),
        trailing: IconButton(
          icon: Icon(
            Icons.favorite,
            color: _isPressed ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            if (widget.itemID != '') {
              !favouritesList.containsKey(widget.itemID)
                  ? favouritesList.add(widget.itemID, widget.item)
                  : favouritesList.remove(widget.itemID);
              isPressed();
            }
          },
        ),
      ),
    );
  }
}
