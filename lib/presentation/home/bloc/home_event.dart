abstract class HomeEvent {}

class Preamble extends HomeEvent {
  final String query;

  Preamble(this.query);
}

class PokemonRandom extends HomeEvent {}

class PokemonByType extends HomeEvent {
  final String query;

  PokemonByType(this.query);
}

class LoadMore extends HomeEvent {}

class PokemonByName extends HomeEvent {
  final String query;

  PokemonByName(this.query);
}
