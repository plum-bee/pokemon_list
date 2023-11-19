import 'package:flutter/material.dart';
import 'pokemon_model.dart';

class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;
  const PokemonDetailPage(this.pokemon, {super.key});

  @override
  _PokemonDetailPageState createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  final double pokemonAvatarSize = 150.0;
  double _sliderValue = 10.0;

  Widget get addYourRating {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Slider(
                  activeColor: const Color(0xFF0B479E),
                  min: 0.0,
                  max: 10.0,
                  onChanged: (newRating) {
                    setState(() {
                      _sliderValue = newRating;
                    });
                  },
                  value: _sliderValue,
                ),
              ),
              Container(
                width: 50.0,
                alignment: Alignment.center,
                child: Text(
                  '${_sliderValue.toInt()}',
                  style: const TextStyle(color: Colors.black, fontSize: 25.0),
                ),
              ),
            ],
          ),
        ),
        submitRatingButton,
      ],
    );
  }

  void updateRating() {
    if (_sliderValue < 5) {
      _ratingErrorDialog();
    } else {
      setState(() {
        widget.pokemon.rating =
            _sliderValue.toInt(); // Change: Updating Pokemon rating
      });
    }
  }

  Future<void> _ratingErrorDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error!'),
            content: const Text("Come on! They're good!"),
            actions: <Widget>[
              TextButton(
                child: const Text('Try Again'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Widget get submitRatingButton {
    return ElevatedButton(
      onPressed: () => updateRating(),
      child: const Text('Submit'),
    );
  }

  Widget get pokemonImage {
    return Hero(
      tag: widget.pokemon,
      child: Container(
        height: pokemonAvatarSize,
        width: pokemonAvatarSize,
        constraints: const BoxConstraints(),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
                offset: Offset(1.0, 2.0),
                blurRadius: 2.0,
                spreadRadius: -1.0,
                color: Color(0x33000000)),
            BoxShadow(
                offset: Offset(2.0, 1.0),
                blurRadius: 3.0,
                spreadRadius: 0.0,
                color: Color(0x24000000)),
            BoxShadow(
                offset: Offset(3.0, 1.0),
                blurRadius: 4.0,
                spreadRadius: 2.0,
                color: Color(0x1f000000))
          ],
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(widget.pokemon.imageUrl ?? ""),
          ),
        ),
      ),
    );
  }

  Widget get rating {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Icon(
          Icons.star,
          size: 40.0,
          color: Colors.black,
        ),
        Text('${widget.pokemon.rating}/10',
            style: const TextStyle(color: Colors.black, fontSize: 30.0))
      ],
    );
  }

  Widget get pokemonProfile {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      decoration: const BoxDecoration(
        color: Color(0xFFABCAED),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          pokemonImage,
          Text(widget.pokemon.name,
              style: const TextStyle(color: Colors.black, fontSize: 32.0)),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: rating,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFABCAED),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B479E),
        title: Text('Meet ${widget.pokemon.name}'),
      ),
      body: ListView(
        children: <Widget>[pokemonProfile, addYourRating],
      ),
    );
  }
}
