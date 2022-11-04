import 'package:flutter/material.dart';
import 'package:homeworks_cpmdwithf/search.dart';
import 'package:provider/provider.dart';

import 'jokes.dart';
import 'favourite.dart';
import 'models/favourite_storage.dart';
import 'search.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const List<Tab> tabs = <Tab>[
    Tab(
      text: 'Favourites',
      icon: Icon(Icons.favorite),
    ),
    Tab(
      text: 'Jokes',
      icon: Icon(Icons.insert_emoticon_rounded),
    ),
    Tab(
      text: 'Search',
      icon: Icon(Icons.search),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Favourites>(
      create: (context) => Favourites(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tinder with Chuck!',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: DefaultTabController(
          length: tabs.length,
          initialIndex: 1,
          child: const Scaffold(
            bottomNavigationBar: BottomAppBar(
              color: Colors.blue,
              child: SafeArea(
                child: TabBar(tabs: tabs),
              ),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                FavouriteScreen(),
                JokeScreen(),
                SearchScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
