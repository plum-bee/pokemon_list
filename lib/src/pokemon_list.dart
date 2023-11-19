import 'package:flutter/material.dart';
import 'pokemon_model.dart';
import 'pokemon_card.dart';

class PokemonList extends StatelessWidget {
  final List<Pokemon> pokemons;

  const PokemonList(this.pokemons, {super.key});

  @override
  Widget build(BuildContext context) {
    return _buildList(context);
  }

  ListView _buildList(context) {
    return ListView.builder(
      itemCount: pokemons.length,
      itemBuilder: (context, index) {
        return PokemonCard(pokemons[index]);
      },
    );
  }
}
