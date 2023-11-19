import 'package:flutter/material.dart';
import 'pokemon_model.dart';
import 'pokemon_detail_page.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonCard(this.pokemon, {super.key});

  @override
  _PokemonCardState createState() => _PokemonCardState(pokemon);
}

class _PokemonCardState extends State<PokemonCard> {
  Pokemon pokemon;
  String? renderUrl;

  _PokemonCardState(this.pokemon);

  @override
  void initState() {
    super.initState();
    renderPokemonPic();
  }

  void renderPokemonPic() async {
    await pokemon.getPokemonDetails();
    if (mounted) {
      setState(() {
        renderUrl = pokemon.imageUrl;
      });
    }
  }

  Widget get pokemonImage {
    var pokemonAvatar = Hero(
      tag: pokemon,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(renderUrl ?? ''),
          ),
        ),
      ),
    );

    Widget placeholder = const CircularProgressIndicator();

    var crossFade = AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: pokemonAvatar,
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 1000),
    );

    return crossFade;
  }

  Widget get pokemonCard {
    return Positioned(
      right: 0.0,
      child: SizedBox(
        width: 290,
        height: 115,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          color: const Color(0xFFF8F8F8),
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  widget.pokemon.name,
                  style:
                      const TextStyle(color: Color(0xFF000600), fontSize: 27.0),
                ),
                Row(
                  children: <Widget>[
                    const Icon(Icons.star, color: Color(0xFF000600)),
                    Text(': ${widget.pokemon.rating}/10',
                        style: const TextStyle(
                            color: Color(0xFF000600), fontSize: 14.0))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showPokemonDetailPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PokemonDetailPage(pokemon);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showPokemonDetailPage(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SizedBox(
          height: 115.0,
          child: Stack(
            children: <Widget>[
              pokemonCard,
              Positioned(top: 7.5, child: pokemonImage),
            ],
          ),
        ),
      ),
    );
  }
}
