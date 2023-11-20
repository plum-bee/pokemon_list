// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'dart:async';

class Pokemon {
  final String name;
  String? imageUrl;
  String? species;
  int? height;
  int? weight;
  List<String>? types;

  int rating = 0;

  Pokemon(this.name);

  Future getPokemonDetails() async {
    if (imageUrl != null &&
        species != null &&
        height != null &&
        weight != null &&
        types != null) {
      return;
    }

    HttpClient http = HttpClient();
    try {
      var formattedName = name.toLowerCase();

      var uri = Uri.https('pokeapi.co', '/api/v2/pokemon/$formattedName');
      var request = await http.getUrl(uri);
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();

      var data = json.decode(responseBody);

      imageUrl = data["sprites"]["front_default"];
      species = data["species"]["name"];
      height = data["height"];
      weight = data["weight"];
      types = (data["types"] as List)
          .map((typeInfo) => typeInfo["type"]["name"].toString())
          .toList();
    } catch (exception) {
      // print(exception);
    }
  }
}
