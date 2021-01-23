
import 'package:fancy_dex/data/entities/pokemon_entity.dart';

abstract class PokemonCacheDataSource{

  cachePokemons(List<PokemonEntity> pokemons);

  cacheDetailPokemon(PokemonEntity pokemon);

  List<PokemonEntity> getCachedPokemons();
}