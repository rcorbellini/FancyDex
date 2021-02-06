import 'package:equatable/equatable.dart';
import 'package:fancy_dex/presentation/models/pokemon_presentation.dart';

abstract class HomeStatus extends Equatable {
  final List<PokemonPresentation> pokemonsLoaded;

  HomeStatus(this.pokemonsLoaded);

  @override
  List<Object> get props => [pokemonsLoaded];
}

class ListLoaded extends HomeStatus {
  ListLoaded(List<PokemonPresentation> pokemons) : super(pokemons ?? []);
}

class ListLoading extends ListLoaded {
  ListLoading({List<PokemonPresentation> lastPokemonsLoaded})
      : super(lastPokemonsLoaded ?? []);
}

class ListError extends ListLoaded {
  ListError({List<PokemonPresentation> lastPokemonsLoaded})
      : super(lastPokemonsLoaded ?? []);
}
