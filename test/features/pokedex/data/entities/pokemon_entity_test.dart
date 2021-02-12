import 'package:fancy_dex/features/pokedex/data/entities/pokemon_entity.dart';
import 'package:fancy_dex/features/pokedex/domain/models/pokemon_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  test('should be a subclass of Pokemon entity', () async {
    //->arrange

    //->act

    //assert
    expect(PokemonEntity(), isA<PokemonModel>());
  });


  test('should set id by url when id is null and url has value', () async {
    //->arrange
    final url = 'https://pokeapi.co/api/v2/pokemon/251/';
    //->act
    final pokemon = PokemonEntity(id: null, url: url);

    //assert
    expect(pokemon.id, equals(251));
  });
}
