import 'dart:async';

import 'package:fancy_dex/core/errors/errors.dart';
import 'package:fancy_dex/core/utils/constants.dart';
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
  //Default list status
  final statusKey = 'status';

  //Filter By Types
  final typesSelectedKey = 'type_selected';
  final typesFilteredStatysKey = 'types_filtered';

  //random & serach by NameOrId
  final pokemonFoundStatus = 'pokemon_found_stat';

  HomeBloc({@required this.pokemonRepository, Fancy fancy}) : super(fancy);

  @protected
  @override
  Future<void> handleEvents(HomeEvent homeEvent) async {
    _dispatchLoading();
    if (homeEvent is LoadPokemonByNameOrId) {
      return _loadPokemonByNameOrId(homeEvent.query);
    } else if (homeEvent is RandomPokemon) {
      return _loadRandomPokemon();
    } else if (homeEvent is LoadMorePokemons) {
      return _loadMorePokemons();
    } else if (homeEvent is LoadPokemonByType) {
      return _loadByType(homeEvent.typeTapped, homeEvent.filteredTypes);
    }
  }

  ///---------------
  /// Handler Events session
  ///---------------
  void _loadPokemonByNameOrId(String query) async {
    if (query.trim().isEmpty) {
      _dispatchPokemons(ListLoaded(lastStatePokemonsLoaded));
      return;
    }
    final result = _isNumeric(query)
        ? await pokemonRepository.getPokemonById(int.parse(query))
        : await pokemonRepository.getPokemonByName(query);

    result.fold(_dispatchError, _dispatchPokemonFound);
  }

  void _loadRandomPokemon() async {
    final result = await pokemonRepository.getRandomPokemon();
    result.fold(_dispatchError, _dispatchPokemonFound);
  }

  List<PokemonPresentation> get lastStatePokemonsLoaded {
    if (map[statusKey] == null) {
      return [];
    }

    return map[statusKey].pokemonsLoaded;
  }

  List<String> get filterTypesApplied {
    if (map[typesFilteredStatysKey] == null) {
      return allTypeColors.keys.toList();
    }

    return map[typesFilteredStatysKey];
  }

  void _loadByType(String typeTapped, List<String> filteredTypes) {
    bool appliedFilter = !filteredTypes.contains(typeTapped);

    if (appliedFilter) {
      filteredTypes.add(typeTapped);
    } else {
      filteredTypes.remove(typeTapped);
    }
    dispatchOn<List<String>>(filteredTypes, key: typesFilteredStatysKey);

    final pokemonsToShow = _applyFiltersOnPokemonList(lastStatePokemonsLoaded);

    _dispatchPokemons(ListLoaded(pokemonsToShow));
  }

  void _loadMorePokemons() async {
    final limit = 20;
    final offset = lastStatePokemonsLoaded.length;
    final result =
        await pokemonRepository.getAllPaged(offset: offset, limit: limit);

    result.fold(_dispatchError, _dispatchListPokemons);
  }

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  ///-----------------
  /// Dispatch Session
  ///-----------------
  void _dispatchError(Error _) =>
      _dispatchStatus(ListError(lastPokemonsLoaded: lastStatePokemonsLoaded));

  void _dispatchLoading() =>
      _dispatchStatus(ListLoading(lastPokemonsLoaded: lastStatePokemonsLoaded));

  void _dispatchPokemonFound(PokemonModel pokemonModel) =>
      _dispatchPokemonFoundStatus(
          PokemonFound(PokemonPresentation.fromModel(pokemonModel)));

  void _dispatchPokemonFoundStatus(PokemonFound homeStatus) {
    dispatchOn<PokemonFound>(homeStatus, key: pokemonFoundStatus);
    //just to stop loading
    _dispatchStatus(ListLoaded(lastStatePokemonsLoaded));
  }

  void _dispatchListPokemons(List<PokemonModel> pokemons) {
    final pokemonsPresentation = pokemons
        .map((pokemonModel) => PokemonPresentation.fromModel(pokemonModel))
        .toList();

    final pokemonsToShow = _applyFiltersOnPokemonList(
        lastStatePokemonsLoaded + pokemonsPresentation);

    _dispatchPokemons(ListLoaded(pokemonsToShow));
  }

  ///Set visibility of pokemons based on filters applied
  List<PokemonPresentation> _applyFiltersOnPokemonList(
      List<PokemonPresentation> pokemons) {
    pokemons.forEach((pokemon) {
      pokemon.visible = pokemon.types
              .where((type) => filterTypesApplied.contains(type['name']))
              .length >
          0;
    });

    return pokemons;
  }

  void _dispatchStatus(HomeStatus homeStatus) =>
      dispatchOn<HomeStatus>(homeStatus, key: statusKey);

  void _dispatchPokemons(HomeListStatus homeStatus) {
    final countPokemons =
        homeStatus.pokemonsLoaded.where((element) => element.visible).length;

    //dispatching to screen show some pokemons
    dispatchOn<HomeStatus>(homeStatus, key: statusKey);

    if (countPokemons < 20 && filterTypesApplied.length > 0) {
      //when apply filter sometimes need to loadmore pokemons
      //to stay with minimum 20 pokemons loaded on screen.
      _loadMorePokemons();
    }
  }
}
