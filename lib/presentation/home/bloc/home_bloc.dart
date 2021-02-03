import 'dart:async';

import 'package:fancy_dex/core/utils/sorted_cache_memory.dart';
import 'package:fancy_dex/core/errors/errors.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';
import 'package:fancy_dex/core/architecture/base_bloc.dart';
import 'package:fancy_dex/presentation/home/bloc/home_event.dart';
import 'package:fancy_dex/presentation/home/bloc/home_status.dart';
import 'package:fancy_dex/presentation/home/models/pokemon_presentation.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:flutter/foundation.dart';

class HomeBloc extends BaseBloc<HomeEvent> {
  final PokemonRepository pokemonRepository;
  final statusPokemonKey = 'pokemon';
  final statusKey = 'status';

  HomeBloc({@required this.pokemonRepository, Fancy fancy}) : super(fancy);


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
    _dispatchLoading();

    final result = await pokemonRepository.getPokemonByName(name);

    result.fold(_dispatchError, _dispatchPokemonAsList);
  }

  void _loadRandomPokemon() async {
    _dispatchLoading();

    final result = await pokemonRepository.getRandomPokemon();

    result.fold(_dispatchError, _dispatchPokemonAsList);
  }

  ListLoaded get currentListLoaded =>
      map[statusPokemonKey] as ListLoaded ?? ListLoaded(SortedCacheMemory());

  void _loadMorePokemons() async {
    _dispatchLoading();

    final limit = 20;
    //falta fazer o controle de concorrencia.
    final offset = currentListLoaded.pokemons.length;
    print('offset $offset');
    final result =
        await pokemonRepository.getAllPaged(offset: offset, limit: limit);

    result.fold(_dispatchError, _dispatchListPokemons);
  }

  ///-----------------
  /// Dispatch Session
  ///-----------------
  void _dispatchError(Error _) => _dispatchStatus(ListError());

  void _dispatchLoading() => _dispatchStatus(ListLoading());

  void _dispatchPokemonAsList(PokemonModel pokemonModel) =>
      _dispatchListPokemons([pokemonModel]);

  void _dispatchListPokemons(List<PokemonModel> pokemons) {
    final pokemonsPresentation = pokemons
        .map((pokemonModel) => PokemonPresentation.fromModel(pokemonModel))
        .toList();

    currentListLoaded.pokemons.addAll(pokemonsPresentation);

    _dispatchPokemons(ListLoaded(currentListLoaded.pokemons));
  }

  void _dispatchStatus(HomeStatus homeStatus) =>
      dispatchOn<HomeStatus>(homeStatus, key: statusKey);

  void _dispatchPokemons(HomeStatus homeStatus) =>
      dispatchOn<HomeStatus>(homeStatus, key: statusPokemonKey);
}
