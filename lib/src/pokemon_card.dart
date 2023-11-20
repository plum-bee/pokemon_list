import 'package:flutter/material.dart';
import 'pokemon_model.dart';
import 'pokemon_detail_page.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;
  final Function(Pokemon) onRatingUpdated;
  final Function() onSortPokemons;

  const PokemonCard(this.pokemon,
      {Key? key, required this.onRatingUpdated, required this.onSortPokemons})
      : super(key: key);

  @override
  _PokemonCardState createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? renderUrl;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    renderPokemonPic();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void renderPokemonPic() async {
    await widget.pokemon.getPokemonDetails();
    if (mounted) {
      setState(() {
        renderUrl = widget.pokemon.imageUrl;
        _animationController.forward();
      });
    }
  }

  Widget get pokemonImage {
    var pokemonAvatar = Hero(
      tag: widget.pokemon,
      child: Container(
        width: 120.0,
        height: 120.0,
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

    return AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: FadeTransition(
        opacity: _animation,
        child: pokemonAvatar,
      ),
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 1000),
    );
  }

  Widget get pokemonCard {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Colors.amberAccent,
      elevation: 4,
      child: Stack(
        children: [
          Positioned(
            child: pokemonImage,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, left: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  widget.pokemon.name,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 27.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Rating: ${widget.pokemon.rating}/10 ',
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14.0,
                      ),
                    ),
                    const Icon(Icons.star, color: Colors.black87, size: 15.0),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showPokemonDetailPage() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PokemonDetailPage(widget.pokemon,
          onRatingUpdated: widget.onRatingUpdated,
          onSortPokemons: widget.onSortPokemons);
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
          child: pokemonCard,
        ),
      ),
    );
  }
}
