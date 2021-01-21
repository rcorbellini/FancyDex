import 'package:fancy_dex/data/entities/pokemon_entity.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should be a subclass of Pokemon entity', () async {
    //->arrange

    //->act

    //assert
    expect(PokemonEntity(), isA<PokemonModel>());
  });
}
