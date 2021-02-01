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

class PokemonCacheDataSourceImp extends PokemonCacheDataSource {
  final CacheMemory<PokemonEntity> memory;

  PokemonCacheDataSourceImp(this.memory);

  @override
  Future<void> cacheDetailPokemon(PokemonEntity pokemon) async {
    memory.add(pokemon);
  }

  @override
  Future<void> cachePokemons(List<PokemonEntity> pokemons) async {
    memory.addAll(pokemons);
  }

  @override
  Future<PokemonEntity> getCachedPokemonById(int id) async {
    return memory.firstWhere((pokemon) => pokemon.id == id, orElse: () => null);
  }

  @override
  Future<PokemonEntity> getCachedPokemonByName(String name) async {
    return memory.firstWhere((pokemon) => pokemon.name == name,
        orElse: () => null);
  }

  @override
  Future<List<PokemonEntity>> getCachedPokemons(
      {int offset = 0, int limit = 20}) async {
    final possibleIDs = List<int>.generate(20, (int index) => index + 1 + offset);
    return memory.where((pokemon) => possibleIDs.contains(pokemon.id)) ?? List.empty();
  }
}
