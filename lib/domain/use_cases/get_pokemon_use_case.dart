import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fancy_dex/core/errors/errors.dart';
import 'package:fancy_dex/core/architecture/use_case.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';
import 'package:flutter/foundation.dart';

class GetPokemonUseCase implements UseCase<FilterGetPokemon, PokemonModel> {
  final PokemonRepository pokemonRepository;

  GetPokemonUseCase(this.pokemonRepository)
      : assert(pokemonRepository != null, "The Repository must be send");

  @override
  Future<Either<Error, PokemonModel>> call(
      {@required FilterGetPokemon params}) {
    assert(params != null, "Params must be send");

    if (params.pokemonId != null) {
      return pokemonRepository.getPokemonById(params.pokemonId);
    } else if (params.pokemonName != null) {
      return pokemonRepository.getPokemonByName(params.pokemonName);
    }

    throw ArgumentError("pokemonName Or pokemonId must not be null");
  }
}

class FilterGetPokemon extends Equatable {
  final String pokemonName;
  final int pokemonId;

  FilterGetPokemon({this.pokemonId, this.pokemonName});

  @override
  List<Object> get props => [
        pokemonId,
        pokemonName,
      ];
}
