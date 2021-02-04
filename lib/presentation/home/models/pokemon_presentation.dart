import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:flutter/cupertino.dart';

class PokemonPresentation extends PokemonModel {
  final String imageUrl;
  final int backgroundColor;

  PokemonPresentation(
      {@required this.backgroundColor,
      @required this.imageUrl,
      @required int id,
      @required String name,
      @required double height,
      @required double weight,
      @required List types})
      : super(
          id: id,
          name: name,
          height: height,
          weight: weight,
          types: types,
        );

  factory PokemonPresentation.fromModel(PokemonModel model) {
    final imageUrl =
        'https://assets.pokemon.com/assets/cms2/img/pokedex/full/${model.id.toString().padLeft(3, '0')}.png';
    final nameCaptalized = model.name
        .split(" ")
        .map((str) => '${str[0].toUpperCase()}${str.substring(1)}')
        .join(" ");

    ///TODO continue...
   // final backgroundColor =

    return PokemonPresentation(
      imageUrl: imageUrl,
      id: model.id,
      name: nameCaptalized,
      height: model.height,
      weight: model.weight,
      types: model.types,
    );
  }
}