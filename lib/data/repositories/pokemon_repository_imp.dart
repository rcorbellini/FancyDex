import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:fancy_dex/core/errors.dart';
import 'package:fancy_dex/core/network_status.dart';
import 'package:fancy_dex/data/data_sources/pokemon_cache_data_source.dart';
import 'package:fancy_dex/data/data_sources/pokemon_remote_data_source.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';
import 'package:flutter/material.dart';

class PokemonRepositoryImp extends PokemonRepository {
  PokemonRepositoryImp({
    @required PokemonCacheDataSource pokemonCacheDataSource,
    @required PokemonRemoteDataSource pokemonRemoteDataSource,
    @required Random random,
    @required NetworkStatus networkStatus,
  });

  @override
  Future<Either<Error, List<PokemonModel>>> getAllPaged(
      {int offset = 0, int limit = 20}) {
    // TODO: implement getAllPaged
    throw UnimplementedError();
  }

  @override
  Future<Either<Error, PokemonModel>> getPokemonById(int id) {
    // TODO: implement getPokemonById
    throw UnimplementedError();
  }

  @override
  Future<Either<Error, PokemonModel>> getPokemonByName(String name) {
    // TODO: implement getPokemonByName
    throw UnimplementedError();
  }

  @override
  Future<Either<Error, PokemonModel>> getRandomPokemon() {
    // TODO: implement getRandomPokemon
    throw UnimplementedError();
  }
}
