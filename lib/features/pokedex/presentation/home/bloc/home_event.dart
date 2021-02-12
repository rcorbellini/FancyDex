abstract class HomeEvent {}

class Preamble extends HomeEvent {
  final String query;

  Preamble(this.query);
}

class RandomPokemon extends HomeEvent {}

class LoadPokemonByType extends HomeEvent {
  final String typeTapped;
  final List<String> filteredTypes;

  LoadPokemonByType(this.typeTapped, this.filteredTypes);
}

class LoadPokemonByNameOrId extends HomeEvent {
  final String query;

  LoadPokemonByNameOrId(this.query);
}

class LoadMorePokemons extends HomeEvent {}
