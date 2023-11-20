import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pokemon_list/src/pokemon_model.dart';
import 'package:pokemon_list/src/pokemon_list.dart';
import 'package:pokemon_list/src/pokemon_add_new.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Favorite Pokemons',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'My Favorite Pokemons'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Pokemon> initialPokemons = [
    Pokemon('Treecko'),
    Pokemon('Torchic'),
    Pokemon('Mudkip'),
  ];

  Future _showNewPokemonForm() async {
    final newPokemon = await Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return const AddPokemonFormPage();
      }),
    );

    if (newPokemon is Pokemon) {
      setState(() {
        initialPokemons.add(newPokemon);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: const Color.fromARGB(255, 88, 111, 137),
        child: Center(
          child: PokemonList(initialPokemons),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewPokemonForm,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
