import 'package:fancy_dex/data/entities/pokemon_entity.dart';

abstract class PokemonRemoteDataSource {
  Future<PokemonEntity> getPokemonById(int name);

  Future<PokemonEntity> getPokemonByName(String name);

  Future<PokemonEntity> getRandomPokemon();

  Future<PokemonEntity> getAllPaged({int offset = 0, int limit = 20});

  //Future<TypeEntity> getAllTypes();
}
