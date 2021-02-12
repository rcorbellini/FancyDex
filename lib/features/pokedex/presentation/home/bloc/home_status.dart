import 'package:equatable/equatable.dart';
import 'package:fancy_dex/features/pokedex/presentation/shared/models/pokemon_presentation.dart';

abstract class HomeStatus extends Equatable {}

//status to search
class PokemonFound extends HomeStatus {
  final PokemonPresentation pokemon;

  PokemonFound(this.pokemon);

  @override
  List<Object> get props => [];
}

//Status to List
abstract class HomeListStatus extends HomeStatus {
  final List<PokemonPresentation> pokemonsLoaded;

  HomeListStatus(this.pokemonsLoaded);

  @override
  List<Object> get props => [pokemonsLoaded];
}

class ListLoaded extends HomeListStatus {
  ListLoaded(List<PokemonPresentation> pokemons) : super(pokemons ?? []);
}

class ListLoading extends HomeListStatus {
  ListLoading({List<PokemonPresentation> lastPokemonsLoaded})
      : super(lastPokemonsLoaded ?? []);
}

class ListError extends HomeListStatus {
  ListError({List<PokemonPresentation> lastPokemonsLoaded})
      : super(lastPokemonsLoaded ?? []);
}
