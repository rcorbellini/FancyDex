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
    } else if (params.random) {
      return pokemonRepository.getRandomPokemon();
    }

    throw ArgumentError("pokemonName Or pokemonId must not be null");
  }
}

class FilterGetPokemon extends Equatable {
  final String pokemonName;
  final int pokemonId;
  final bool random;

  FilterGetPokemon({this.pokemonId, this.pokemonName, this.random = false});

  FilterGetPokemon.byName(String name)
      : this.pokemonName = name,
        this.random = false,
        this.pokemonId = null;

  FilterGetPokemon.byId(int id)
      : this.pokemonName = null,
        this.random = false,
        this.pokemonId = id;

  FilterGetPokemon.byRandom()
      : this.pokemonName = null,
        this.random = true,
        this.pokemonId = null;

  @override
  List<Object> get props => [pokemonId, pokemonName, random];
}
