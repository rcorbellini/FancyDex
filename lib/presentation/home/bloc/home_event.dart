abstract class HomeEvent {}

class Preamble extends HomeEvent {
  final String query;

  Preamble(this.query);
}

class RandomPokemon extends HomeEvent {}

class LoadPokemonByType extends HomeEvent {
  final String query;

  LoadPokemonByType(this.query);
}

class LoadPokemonByName extends HomeEvent {
  final String query;

  LoadPokemonByName(this.query);
}

class LoadMorePokemons extends HomeEvent {}
