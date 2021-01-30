import 'package:fancy_dex/data/entities/pokemon_entity.dart';

abstract class PokemonCacheDataSource {
  Future<void> cachePokemons(List<PokemonEntity> pokemons);

  Future<void> cacheDetailPokemon(PokemonEntity pokemon);

  Future<List<PokemonEntity>> getCachedPokemons();

  Future<PokemonEntity> getCachedPokemonByName(String name);
}
