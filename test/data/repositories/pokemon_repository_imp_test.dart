import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:fancy_dex/core/errors.dart';
import 'package:fancy_dex/core/exceptions.dart';
import 'package:fancy_dex/core/network_status.dart';
import 'package:fancy_dex/data/data_sources/pokemon_cache_data_source.dart';
import 'package:fancy_dex/data/data_sources/pokemon_remote_data_source.dart';
import 'package:fancy_dex/data/entities/pokemon_entity.dart';
import 'package:fancy_dex/data/repositories/pokemon_repository_imp.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockLocalDataSource extends Mock implements PokemonCacheDataSource {}

class MockRemoteDataSource extends Mock implements PokemonRemoteDataSource {}

class MockNetworkStatus extends Mock implements NetworkStatus {}

class MockRandom extends Mock implements Random {}

void main() {
  MockLocalDataSource mockLocalDataSource;
  MockRemoteDataSource mockRemoteDataSource;
  PokemonRepositoryImp repository;
  MockNetworkStatus mockNetworkStatus;
  MockRandom mockRandom;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkStatus = MockNetworkStatus();
    mockRandom = MockRandom();
    repository = PokemonRepositoryImp(
        pokemonRemoteDataSource: mockRemoteDataSource,
        pokemonCacheDataSource: mockLocalDataSource,
        random: mockRandom,
        networkStatus: mockNetworkStatus);
  });

  void runOnline(Function func) {
    group('device online', () {
      setUp(() {
        when(mockNetworkStatus.isConnected).thenAnswer((_) async => true);
      });

      func();
    });
  }

  void runOffline(Function func) {
    group('device offline', () {
      setUp(() {
        when(mockNetworkStatus.isConnected).thenAnswer((_) async => false);
      });

      func();
    });
  }

  group('getPokemonByName', () {
    final name = "Ditto";
    final pokemonModel = PokemonEntity(
      id: 1,
      name: "Ditto",
      weight: 15,
      height: 30,
      types: [],
    );

    final PokemonModel pokemonEntity = pokemonModel;

    test('should verify if isConnect when call getbyname', () async {
      //arrange
      when(mockNetworkStatus.isConnected).thenAnswer((_) async => true);
      //act
      repository.getPokemonByName(name);
      //assert
      verify(mockNetworkStatus.isConnected);
    });

    runOnline(() {
      test(
          'should return PokemonMode using remote if is online and should cache it',
          () async {
        //arrange
        when(mockRemoteDataSource.getPokemonByName(any))
            .thenAnswer((_) async => pokemonEntity);
        //act
        final result = await repository.getPokemonByName(name);
        //assert
        verify(mockRemoteDataSource.getPokemonByName(name));
        verifyNever(mockLocalDataSource.getCachedPokemonByName(any));
        verify(mockLocalDataSource.cacheDetailPokemon(pokemonEntity));
        expect(result, equals(Right(pokemonModel)));
      });

      test('should return Error when exception are raised from remote',
          () async {
        //arrange
        when(mockRemoteDataSource.getPokemonByName(any))
            .thenThrow(RemoteException());
        //act
        final result = await repository.getPokemonByName(name);
        //assert
        verifyZeroInteractions(mockLocalDataSource);
        verify(mockRemoteDataSource.getPokemonByName(name));
        expect(result, equals(Left(RemoteError())));
      });
    });

    runOffline(() {
      setUp(() {
        when(mockNetworkStatus.isConnected).thenAnswer((_) async => false);
      });

      test(
          'should return cached pokemon by name when is offline and cache exist',
          () async {
        //arrange
        when(mockLocalDataSource.getCachedPokemons())
            .thenAnswer((_) async => [pokemonEntity]);
        //act
        final result = await repository.getPokemonByName(name);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getCachedPokemonByName(name));
        expect(result, Right(pokemonModel));
      });
      test('should return CacheError when exception from cache are rised',
          () async {
        //arrange
        when(mockLocalDataSource.getCachedPokemonByName(name))
            .thenThrow(CacheException());
        //act
        final result = await repository.getPokemonByName(name);
        //assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getCachedPokemonByName(name));
        expect(result, Left(CacheError()));
      });
    });
  });

  group('getRandomPokemon', () {
    final random = 132;
    final pokemonModel = PokemonModel(
      id: 1,
      name: "Ditto",
      weight: 15,
      height: 30,
      types: [],
    );

    test('should verify if isConnected are call when getRandomPokemon',
        () async {
      //arrange
      when(mockNetworkStatus.isConnected).thenAnswer((_) async => true);
      when(mockRandom.nextInt(any)).thenReturn(random);
      //act
      repository.getRandomPokemon();
      //assert
      verify(mockNetworkStatus.isConnected);
    });

    runOnline(() {
      test(
          'should return pokemonModel using remoteDataSource when isOnline and should cache it',
          () async {
        //->arrange
        when(mockRandom.nextInt(any)).thenReturn(random);
        when(mockRemoteDataSource.getPokemonById(any))
            .thenAnswer((_) async => pokemonModel);

        //->act
        final result = await repository.getRandomPokemon();

        //->assert
        verify(mockRandom.nextInt(any));
        //Geeting remote
        verify(mockRemoteDataSource.getPokemonById(random));
        verifyNoMoreInteractions(mockRemoteDataSource);

        //can't use local for any get
        verifyNever(mockLocalDataSource.getCachedPokemons());
        verifyNever(mockLocalDataSource.getCachedPokemonByName(any));
        //use local just for cache
        verify(mockLocalDataSource.cacheDetailPokemon(pokemonModel));
        verifyNoMoreInteractions(verifyNoMoreInteractions);
        expect(result, equals(Right(pokemonModel)));
      });

      test(
          'should return RemoteError when exception rise from remote',
          () async {
        //arrange
        when(mockRandom.nextInt(any)).thenReturn(random);
        when(mockRemoteDataSource.getPokemonById(any))
            .thenThrow(RemoteException());
        //act
        final result = await repository.getRandomPokemon();
        //assert
        verify(mockRandom.nextInt(any));
        //tryng to get a remote
        verify(mockRemoteDataSource.getPokemonById(random));
        verifyNoMoreInteractions(mockRemoteDataSource);
        //with exception are nothing to cache
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(RemoteError())));
      });
    });



    runOffline((){
      test('should return pokemonModel from cache when isOffline', () async{
        final cached =  [pokemonModel];
        final sizeCached = cached.length;
        when(mockRandom.nextInt(any)).thenReturn(random);
        when(mockLocalDataSource.getCachedPokemons())
            .thenAnswer((_) async => [pokemonModel]);
        //act
        final result = await repository.getRandomPokemon();
        //assert
        //verify if are sorting with max of cached options
        verify(mockRandom.nextInt(sizeCached-1));
        verify(mockLocalDataSource.getCachedPokemons());

        verifyZeroInteractions(mockRemoteDataSource);

        expect(result, equals(Right(pokemonModel)));

        expect(cached.contains(result.getOrElse(() => null)), isTrue);
      });
    });
  });
}
