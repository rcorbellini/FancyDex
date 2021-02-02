import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';
import 'package:fancy_dex/presentation/base_bloc.dart';
import 'package:fancy_dex/presentation/home/bloc/home_event.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:flutter/foundation.dart';

class HomeBloc extends BaseBloc<HomeEvent> {
  final PokemonRepository pokemonRepository;

  HomeBloc({@required this.pokemonRepository, Fancy fancy}): super(fancy);

  @override
  void handleEvents(HomeEvent homeEvent){
    throw UnimplementedError("wip");
  }
}
