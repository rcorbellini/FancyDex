import 'package:fancy_dex/core/errors.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';
import 'package:fancy_dex/presentation/base_bloc.dart';
import 'package:fancy_dex/presentation/home/bloc/home_event.dart';
import 'package:fancy_dex/presentation/home/bloc/home_status.dart';
import 'package:fancy_dex/presentation/home/models/pokemon_presentation.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:flutter/foundation.dart';

class HomeBloc extends BaseBloc<HomeEvent> {
  final PokemonRepository pokemonRepository;

  HomeBloc({@required this.pokemonRepository, Fancy fancy}) : super(fancy);

  @protected
  @override
  Future<void> handleEvents(HomeEvent homeEvent) async {
    if (homeEvent is PokemonByName) {
      return _loadPokemonByName(homeEvent.query);
    } else if (homeEvent is PokemonRandom) {
      return _loadRandomPokemon();
    } else if (homeEvent is LoadMore) {
      return _loadMorePokemons();
    }
  }

  ///---------------
  /// Handler Events session
  ///---------------
  void _loadPokemonByName(String name) async {
    _dispatchLoading();

    final result = await pokemonRepository.getPokemonByName(name);

    result.fold(_dispatchError, _dispatchPokemonAsList);
  }

  void _loadRandomPokemon() async {
    _dispatchLoading();

    final result = await pokemonRepository.getRandomPokemon();

    result.fold(_dispatchError, _dispatchPokemonAsList);
  }

  ///da pra melhorar movendo para trás de um repository
  int _offset = 0;

  void _loadMorePokemons() async {
    _dispatchLoading();

    final limit = 20;
    final result = await pokemonRepository.getAllPaged(offset: _offset, limit: limit);
    _offset += limit;

    result.fold(_dispatchError, _dispatchListPokemons);
  }

  ///-----------------
  /// Dispatch Status Session
  ///-----------------
  void _dispatchError(Error _) => _dispatchStatus(ListError());

  void _dispatchLoading() => _dispatchStatus(ListLoading());

  void _dispatchPokemonAsList(PokemonModel pokemonModel) =>
      _dispatchListPokemons([pokemonModel]);

  void _dispatchListPokemons(List<PokemonModel> pokemons) {
    final pokemonsPresentation = pokemons
        .map((pokemonModel) => PokemonPresentation.fromModel(pokemonModel))
        .toList();

    _dispatchStatus(ListLoaded(pokemonsPresentation));
  }

  void _dispatchStatus(HomeStatus homeStatus) => dispatchOn<HomeStatus>(homeStatus);
}
