import 'dart:async';

import 'package:fancy_dex/core/architecture/base_bloc.dart';
import 'package:fancy_dex/core/errors/errors.dart';
import 'package:fancy_dex/features/pokedex/domain/models/pokemon_model.dart';
import 'package:fancy_dex/features/pokedex/domain/use_cases/get_pokemon_use_case.dart';
import 'package:fancy_dex/features/pokedex/presentation/detail/bloc/detail_event.dart';
import 'package:fancy_dex/features/pokedex/presentation/detail/bloc/detail_status.dart';
import 'package:fancy_dex/features/pokedex/presentation/shared/models/pokemon_presentation.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:flutter/foundation.dart';

class DetailBloc extends BaseBloc<DetailEvent> {
  final GetPokemonUseCase getPokemonUseCase;
  final statusKey = 'status';

  DetailBloc({@required this.getPokemonUseCase, Fancy fancy}) : super(fancy);

  @override
  void init() {
    super.init();
    listenOn<DetailEvent>(_dispatchLoading, key: eventKey);
  }

  @protected
  @override
  Future<void> handleEvents(DetailEvent event) async {
    if (event is LoadById) {
      return _loadPokemonById(event.id);
    }
  }

  ///---------------
  /// Handler Events session
  ///---------------
  void _loadPokemonById(int id) async {
    final result =
        await getPokemonUseCase.call(params: FilterGetPokemon(pokemonId: id));

    result.fold(_dispatchError, _dispatchPokemon);
  }

  ///-----------------
  /// Dispatch Session
  ///-----------------
  void _dispatchError(Error _) => _dispatchStatus(PokemonError());

  void _dispatchLoading([DetailEvent _]) => _dispatchStatus(PokemonLoading());

  void _dispatchPokemon(PokemonModel pokemonModel) {
    final pokemonPresentation = PokemonPresentation.fromModel(pokemonModel);

    _dispatchStatus(PokemonLoaded(pokemon: pokemonPresentation));
  }

  void _dispatchStatus(DetailStatus status) =>
      dispatchOn<DetailStatus>(status, key: statusKey);
}
