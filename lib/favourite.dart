import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/favourite_storage.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
      ),
      body: SafeArea(
        child: Consumer<Favourites>(
          builder: (context, value, child) => value.isNotEmpty()
              ? ListView.builder(
                  itemCount: value.length(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemBuilder: (context, index) => FavouriteItemTile(
                      value.keys.elementAt(index),
                      value.get(value.keys.elementAt(index))!),
                )
              : const Center(
                  child: Text('No favourites to see'),
                ),
        ),
      ),
    );
  }
}

class FavouriteItemTile extends StatelessWidget {
  final String itemID;
  final String item;

  const FavouriteItemTile(this.itemID, this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(item),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete,
            color: Colors.red,
          ),
          onPressed: () {
            context.read<Favourites>().remove(itemID);
          },
        ),
      ),
    );
  }
}
