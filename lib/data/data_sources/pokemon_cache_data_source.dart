import 'package:fancy_dex/data/entities/pokemon_entity.dart';

abstract class PokemonCacheDataSource {
  Future<void> cachePokemons(List<PokemonEntity> pokemons);

  Future<void> cacheDetailPokemon(PokemonEntity pokemon);

  Future<List<PokemonEntity>> getCachedPokemons(
      {int offset = 0, int limit = 20});

  Future<PokemonEntity> getCachedPokemonByName(String name);

  Future<PokemonEntity> getCachedPokemonById(int id);
}
