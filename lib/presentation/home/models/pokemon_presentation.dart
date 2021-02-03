import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:flutter/cupertino.dart';

class PokemonPresentation extends PokemonModel {
  PokemonPresentation(
      {@required int id,
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
    return PokemonPresentation(
      id: model.id,
      name: model.name,
      height: model.height,
      weight: model.weight,
      types: model.types,
    );
  }
}
