import 'package:fancy_dex/core/utils/constants.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:flutter/cupertino.dart';

class PokemonPresentation extends PokemonModel {
  final String imageUrl;
  final String descritibleId;

  PokemonPresentation(
      {@required this.imageUrl,
      @required this.descritibleId,
      @required int id,
      @required String name,
      @required double height,
      @required double weight,
      @required List types,
      @required List stats})
      : super(
            id: id,
            name: name,
            height: height,
            weight: weight,
            types: types,
            stats: stats);
  int get primaryColor => types[0]['color'];

  Map<String, int> get statsToMap =>
      Map.fromIterable(stats, key: (v) => v['name'], value: (v) => v['value']);

  factory PokemonPresentation.fromModel(PokemonModel model) {
    final imageUrl =
        'https://assets.pokemon.com/assets/cms2/img/pokedex/full/${model.id.toString().padLeft(3, '0')}.png';
    final nameCaptalized = model.name
        .split(" ")
        .map((str) => '${str[0].toUpperCase()}${str.substring(1)}')
        .join(" ");

    final descritibleId = model.id.toString().padLeft(3, '0');

    final typesNames =
        (model.types.map((type) => type['type']['name']).toList());
    print(typesNames);

    final types = typesNames
        .map(
            (typeName) => {'name': typeName, 'color': typeToIntColor[typeName]})
        .toList();
    print(types);

    final height = model.height / 10;

    final weight = model.weight / 10;

    final List<Map<String, dynamic>> statsList = model.stats
        .map((st) => <String, dynamic>{
              'name': st['stat']['name'],
              'value': st['base_stat']
            })
        .toList();

    return PokemonPresentation(
      imageUrl: imageUrl,
      id: model.id,
      descritibleId: descritibleId,
      name: nameCaptalized,
      height: height,
      weight: weight,
      types: types,
      stats: statsList,
    );
  }
}
