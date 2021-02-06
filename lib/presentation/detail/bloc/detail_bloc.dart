import 'dart:async';

import 'package:fancy_dex/core/errors/errors.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';
import 'package:fancy_dex/core/architecture/base_bloc.dart';
import 'package:fancy_dex/presentation/detail/bloc/detail_event.dart';
import 'package:fancy_dex/presentation/detail/bloc/detail_status.dart';
import 'package:fancy_dex/presentation/home/bloc/home_event.dart';
import 'package:fancy_dex/presentation/home/bloc/home_status.dart';
import 'package:fancy_dex/presentation/models/pokemon_presentation.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:flutter/foundation.dart';

class DetailBloc extends BaseBloc<DetailEvent> {
  final PokemonRepository pokemonRepository;
  final statusKey = 'status';

  DetailBloc({@required this.pokemonRepository, Fancy fancy}) : super(fancy);

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
    final result = await pokemonRepository.getPokemonById(id);

    result.fold(_dispatchError, _dispatchPokemon);
  }

  ///-----------------
  /// Dispatch Session
  ///-----------------
  void _dispatchError(Error _) =>
      _dispatchStatus(PokemonError());

  void _dispatchLoading([DetailEvent _]) =>
      _dispatchStatus(PokemonLoading());

  void _dispatchPokemon(PokemonModel pokemonModel) {
    final pokemonPresentation =  PokemonPresentation.fromModel(pokemonModel);

    _dispatchStatus(
        PokemonLoaded(pokemon: pokemonPresentation));
  }

  void _dispatchStatus(DetailStatus status) =>
      dispatchOn<DetailStatus>(status, key: statusKey);
}
