import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:fancy_dex/core/errors/errors.dart';
import 'package:fancy_dex/core/errors/exceptions.dart';
import 'package:fancy_dex/core/utils/network_status.dart';
import 'package:fancy_dex/features/pokedex/data/data_sources/pokemon_cache_data_source.dart';
import 'package:fancy_dex/features/pokedex/data/data_sources/pokemon_remote_data_source.dart';
import 'package:fancy_dex/features/pokedex/domain/models/pokemon_model.dart';
import 'package:fancy_dex/features/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:flutter/material.dart';

const lastPokemonId = 898;

class PokemonRepositoryImp extends PokemonRepository {
  final PokemonCacheDataSource pokemonCacheDataSource;
  final PokemonRemoteDataSource pokemonRemoteDataSource;
  final Random random;
  final NetworkStatus networkStatus;

  PokemonRepositoryImp({
    @required this.pokemonCacheDataSource,
    @required this.pokemonRemoteDataSource,
    @required this.random,
    @required this.networkStatus,
  });

  ///Vai buscar todos pokemon de forma paginada, faz o chaveamento
  ///entre obter do cache ou remoto de acordo com o status da networt
  @override
  Future<Either<Error, List<PokemonModel>>> getAllPaged(
      {int offset = 0, int limit = 20}) async {
    if (await networkStatus.isConnected) {
      final pokemonsRemote = await pokemonRemoteDataSource.getAllPaged(
          offset: offset, limit: limit);
      final pokemonsFullRemote = await Future.wait(pokemonsRemote
          .map((pokemon) => pokemonRemoteDataSource.getPokemonById(pokemon.id))
          .toList());
      await pokemonCacheDataSource.cachePokemons(pokemonsFullRemote);
      return Right(pokemonsFullRemote);
    }

    final pokemonsCached = await pokemonCacheDataSource.getCachedPokemons(
        offset: offset, limit: limit);
    return Right(pokemonsCached);
  }

  @override
  Future<Either<Error, PokemonModel>> getPokemonById(int id) async {
    if (await networkStatus.isConnected) {
      try {
        final pokemonRemote = await pokemonRemoteDataSource.getPokemonById(id);
        await pokemonCacheDataSource.cacheDetailPokemon(pokemonRemote);
        return Right(pokemonRemote);
      } on RemoteException {
        return Left(RemoteError());
      }
    }

    try {
      final pokemonsCached =
          await pokemonCacheDataSource.getCachedPokemonById(id);
      return Right(pokemonsCached);
    } on CacheException {
      return Left(CacheError());
    }
  }

  @override
  Future<Either<Error, PokemonModel>> getPokemonByName(String name) async {
    if (await networkStatus.isConnected) {
      try {
        final pokemonRemote =
            await pokemonRemoteDataSource.getPokemonByName(name);
        await pokemonCacheDataSource.cacheDetailPokemon(pokemonRemote);
        return Right(pokemonRemote);
      } on RemoteException {
        return Left(RemoteError());
      }
    }
    try {
      final pokemonsCached =
          await pokemonCacheDataSource.getCachedPokemonByName(name);
      return Right(pokemonsCached);
    } on CacheException {
      return Left(CacheError());
    }
  }

  @override
  Future<Either<Error, PokemonModel>> getRandomPokemon() async {
    final sortedId = random.nextInt(lastPokemonId + 1);

    if (await networkStatus.isConnected) {
      try {
        final pokemonRemote =
            await pokemonRemoteDataSource.getPokemonById(sortedId);
        await pokemonCacheDataSource.cacheDetailPokemon(pokemonRemote);
        return Right(pokemonRemote);
      } on RemoteException {
        return Left(RemoteError());
      }
    }

    try {
      //mesmo sabendo que o ID pode nao existir no cache, resolvo tentar pegar,
      //poi se eu me limitar a pegar somente o que ta no cache posso viciar o random.
      final pokemonsCached =
          await pokemonCacheDataSource.getCachedPokemonById(sortedId);
      return Right(pokemonsCached);
    } on CacheException {
      return Left(CacheError());
    }
  }
}
