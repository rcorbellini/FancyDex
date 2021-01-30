import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:flutter/foundation.dart';

class PokemonEntity extends PokemonModel {
  PokemonEntity(
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

  factory PokemonEntity.fromJson(Map<String, dynamic> json) {
    return PokemonEntity(
      id: json['id'] as int,
      name: json['name'] as String,
      height: (json['height'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      types: json['types'] as List,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': this.id,
        'name': this.name,
        'height': this.height,
        'weight': this.weight,
        'types': this.types,
      };
}