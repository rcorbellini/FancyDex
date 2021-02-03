import 'package:equatable/equatable.dart';
import 'package:fancy_dex/core/utils/sorted_cache_memory.dart';
import 'package:fancy_dex/presentation/home/models/pokemon_presentation.dart';

abstract class HomeStatus extends Equatable{}

class ListLoaded extends HomeStatus {
  final SortedCacheMemory<PokemonPresentation> pokemons;

  ListLoaded(this.pokemons);

  @override
  // TODO: implement props
  List<Object> get props => [pokemons];
}

class ListLoading extends HomeStatus {
  @override
  List<Object> get props => [];
}

class ListError extends HomeStatus{
  @override
  List<Object> get props => [];

}