import 'package:fancy_dex/presentation/home/models/pokemon_presentation.dart';

abstract class HomeStatus {}

class ListLoaded extends HomeStatus {
  final List<PokemonPresentation> pokemons;

  ListLoaded(this.pokemons);
}

class ListLoading extends HomeStatus {
}

class ListError extends HomeStatus{

}