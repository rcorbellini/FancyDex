import 'package:equatable/equatable.dart';
import 'package:fancy_dex/features/pokedex/presentation/shared/models/pokemon_presentation.dart';

abstract class DetailStatus extends Equatable {
  final PokemonPresentation pokemonLoaded;

  DetailStatus(this.pokemonLoaded);

  @override
  List<Object> get props => [pokemonLoaded];
}

class PokemonLoaded extends DetailStatus {
  PokemonLoaded({PokemonPresentation pokemon}) : super(pokemon);
}

class PokemonLoading extends DetailStatus {
  PokemonLoading({PokemonPresentation lastPokemonLoaded})
      : super(lastPokemonLoaded);
}

class PokemonError extends DetailStatus {
  PokemonError({PokemonPresentation lastPokemonLoaded})
      : super(lastPokemonLoaded);
}
