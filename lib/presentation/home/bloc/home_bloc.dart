import 'dart:async';

import 'package:fancy_dex/core/errors/errors.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';
import 'package:fancy_dex/core/architecture/base_bloc.dart';
import 'package:fancy_dex/presentation/home/bloc/home_event.dart';
import 'package:fancy_dex/presentation/home/bloc/home_status.dart';
import 'package:fancy_dex/presentation/models/pokemon_presentation.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:flutter/foundation.dart';

class HomeBloc extends BaseBloc<HomeEvent> {
  final PokemonRepository pokemonRepository;
  final statusKey = 'status';

  HomeBloc({@required this.pokemonRepository, Fancy fancy}) : super(fancy);

  @override
  void init() {
    super.init();

    listenOn<HomeEvent>(_dispatchLoading, key: eventKey);
  }

  @protected
  @override
  Future<void> handleEvents(HomeEvent homeEvent) async {
    if (homeEvent is LoadPokemonByName) {
      return _loadPokemonByName(homeEvent.query);
    } else if (homeEvent is RandomPokemon) {
      return _loadRandomPokemon();
    } else if (homeEvent is LoadMorePokemons) {
      return _loadMorePokemons();
    }
  }

  ///---------------
  /// Handler Events session
  ///---------------
  void _loadPokemonByName(String name) async {
    final result = await pokemonRepository.getPokemonByName(name);

    result.fold(_dispatchError, _dispatchPokemonAsList);
  }

  void _loadRandomPokemon() async {
    final result = await pokemonRepository.getRandomPokemon();

    result.fold(_dispatchError, _dispatchPokemonAsList);
  }

  List<PokemonPresentation> get lastStatePokemonsLoaded {
    if (map[statusKey] == null) {
      return [];
    }

    return map[statusKey].pokemonsLoaded;
  }

  //falta fazer o controle de concorrencia.
  void _loadMorePokemons() async {
    final limit = 20;
    final offset = lastStatePokemonsLoaded.length;
    final result =
        await pokemonRepository.getAllPaged(offset: offset, limit: limit);

    result.fold(_dispatchError, _dispatchListPokemons);
  }

  ///-----------------
  /// Dispatch Session
  ///-----------------
  void _dispatchError(Error _) =>
      _dispatchStatus(ListError(lastPokemonsLoaded: lastStatePokemonsLoaded));

  void _dispatchLoading([HomeEvent _]) =>
      _dispatchStatus(ListLoading(lastPokemonsLoaded: lastStatePokemonsLoaded));

  void _dispatchPokemonAsList(PokemonModel pokemonModel) =>
      _dispatchListPokemons([pokemonModel]);

  void _dispatchListPokemons(List<PokemonModel> pokemons) {
    print('pokemonsloaded ${pokemons.length}');
    final pokemonsPresentation = pokemons
        .map((pokemonModel) => PokemonPresentation.fromModel(pokemonModel))
        .toList();

    _dispatchPokemons(
        ListLoaded(lastStatePokemonsLoaded + pokemonsPresentation));
  }

  void _dispatchStatus(HomeStatus homeStatus) =>
      dispatchOn<HomeStatus>(homeStatus, key: statusKey);

  void _dispatchPokemons(HomeStatus homeStatus) =>
      dispatchOn<HomeStatus>(homeStatus, key: statusKey);
}
