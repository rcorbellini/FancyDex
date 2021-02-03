import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:flutter/cupertino.dart';

class PokemonPresentation extends PokemonModel {
  final String imageUrl;
  PokemonPresentation(
      {@required this.imageUrl,
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
    return PokemonPresentation(
      imageUrl: imageUrl,
      id: model.id,
      name: model.name,
      height: model.height,
      weight: model.weight,
      types: model.types,
    );
  }
}
