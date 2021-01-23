import 'package:fancy_dex/data/entities/pokemon_entity.dart';

abstract class PokemonRemoteDataSource {
  Future<PokemonEntity> getPokemon(String name);

  Future<PokemonEntity> getRandomPokemon();

  Future<PokemonEntity> getAllPaged({int offset = 0, int limit = 20});

  //Future<TypeEntity> getAllTypes();
}
