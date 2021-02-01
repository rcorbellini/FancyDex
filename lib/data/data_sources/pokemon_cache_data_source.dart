import 'package:fancy_dex/core/cache_memory.dart';
import 'package:fancy_dex/data/entities/pokemon_entity.dart';

abstract class PokemonCacheDataSource {
  Future<void> cachePokemons(List<PokemonEntity> pokemons);

  Future<void> cacheDetailPokemon(PokemonEntity pokemon);

  Future<List<PokemonEntity>> getCachedPokemons(
      {int offset = 0, int limit = 20});

  Future<PokemonEntity> getCachedPokemonByName(String name);

  Future<PokemonEntity> getCachedPokemonById(int id);
}


class PokemonCacheDataSourceImp extends PokemonCacheDataSource{
  final CacheMemory<PokemonEntity> memory;

  PokemonCacheDataSourceImp(this.memory);

  @override
  Future<void> cacheDetailPokemon(PokemonEntity pokemon) {
    // TODO: implement cacheDetailPokemon
    throw UnimplementedError();
  }

  @override
  Future<void> cachePokemons(List<PokemonEntity> pokemons) {
    // TODO: implement cachePokemons
    throw UnimplementedError();
  }

  @override
  Future<PokemonEntity> getCachedPokemonById(int id) {
    // TODO: implement getCachedPokemonById
    throw UnimplementedError();
  }

  @override
  Future<PokemonEntity> getCachedPokemonByName(String name) {
    // TODO: implement getCachedPokemonByName
    throw UnimplementedError();
  }

  @override
  Future<List<PokemonEntity>> getCachedPokemons({int offset = 0, int limit = 20}) {
    // TODO: implement getCachedPokemons
    throw UnimplementedError();
  }
  
}