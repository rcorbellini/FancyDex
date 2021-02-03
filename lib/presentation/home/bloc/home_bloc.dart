import 'package:fancy_dex/core/cache_memory.dart';
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

  int _offset = 0;
  final CacheMemory<PokemonModel> _pokemonsLoaded = CacheMemory();

  void _loadMorePokemons() async {
    print(map);
    _dispatchLoading();

    final limit = 20;
    final result =
        await pokemonRepository.getAllPaged(offset: _offset, limit: limit);
    _offset += limit;

    result.fold(_dispatchError, (pokemons) {
      _pokemonsLoaded.addAll(pokemons);
      print('------ ${_pokemonsLoaded.toList().length}');
      print(_pokemonsLoaded.toList());
      print('----');
      _dispatchListPokemons(_pokemonsLoaded.toList());
    });
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

    _dispatchStatus(ListLoaded(pokemonsPresentation));
  }

  void _dispatchStatus(HomeStatus homeStatus) =>
      dispatchOn<HomeStatus>(homeStatus);
}
