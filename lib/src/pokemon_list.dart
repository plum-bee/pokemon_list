import 'package:flutter/material.dart';
import 'pokemon_model.dart';
import 'pokemon_card.dart';

class PokemonList extends StatefulWidget {
  final List<Pokemon> pokemons;
  final Function() onSortPokemons;

  const PokemonList(this.pokemons, {Key? key, required this.onSortPokemons})
      : super(key: key);

  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  void _updateRating(Pokemon updatedPokemon) {
    setState(() {
      int index =
          widget.pokemons.indexWhere((p) => p.name == updatedPokemon.name);
      if (index != -1) {
        widget.pokemons[index] = updatedPokemon;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.pokemons.length,
      itemBuilder: (context, index) {
        return PokemonCard(widget.pokemons[index],
            onRatingUpdated: _updateRating,
            onSortPokemons: widget.onSortPokemons);
      },
    );
  }
}
