import 'package:flutter/material.dart';
import 'pokemon_model.dart';

class PokemonDetailPage extends StatefulWidget {
  final Pokemon pokemon;
  final Function(Pokemon) onRatingUpdated;

  const PokemonDetailPage(this.pokemon,
      {Key? key, required this.onRatingUpdated})
      : super(key: key);

  @override
  _PokemonDetailPageState createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  final double pokemonAvatarSize = 200.0;
  double _sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.pokemon.rating.toDouble();
    widget.pokemon.getPokemonDetails().then((_) {
      setState(() {});
    });
  }

  SliderThemeData _sliderStyle() {
    return SliderTheme.of(context).copyWith(
      activeTrackColor: Colors.orange,
      inactiveTrackColor: Colors.orange[200],
      trackShape: const RoundedRectSliderTrackShape(),
      trackHeight: 4.0,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
      thumbColor: Colors.orange,
      overlayColor: Colors.orange.withOpacity(0.3),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
      tickMarkShape: const RoundSliderTickMarkShape(),
      activeTickMarkColor: Colors.orange,
      inactiveTickMarkColor: Colors.orange[200],
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorColor: Colors.orange,
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
      ),
    );
  }

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
                child: SliderTheme(
                  data: _sliderStyle(),
                  child: Slider(
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
    if (_sliderValue < 3) {
      _ratingErrorDialog();
    } else {
      setState(() {
        widget.pokemon.rating = _sliderValue.toInt();
        widget.onRatingUpdated(widget.pokemon);
      });
    }
  }

  Future<void> _ratingErrorDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        textStyle: const TextStyle(fontSize: 15),
      ),
      child: const Text(
        'Rate it!',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget get pokemonImage {
    return Hero(
      tag: widget.pokemon,
      child: Container(
        height: pokemonAvatarSize,
        width: pokemonAvatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
            ),
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
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${widget.pokemon.rating}/10',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 25.0,
            ),
          ),
          const Icon(
            Icons.star,
            size: 30.0,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget get pokemonProfile {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32.0),
      decoration: BoxDecoration(
        color: Colors.indigoAccent,
        border: Border.all(color: Colors.grey, width: 5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          pokemonImage,
          const SizedBox(height: 20.0),
          Text(
            widget.pokemon.name,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 32.0,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: rating,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'Height: ${widget.pokemon.height?.toString() ?? "Unknown"}',
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              'Weight: ${widget.pokemon.weight?.toString() ?? "Unknown"}',
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              'Types: ${widget.pokemon.types?.join(', ') ?? "Unknown"}',
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          'Meet ${widget.pokemon.name}',
          style: const TextStyle(
            color: Colors.black87,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          pokemonProfile,
          addYourRating,
        ],
      ),
    );
  }
}
