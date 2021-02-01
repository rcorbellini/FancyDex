import 'dart:convert';

import 'package:fancy_dex/core/exceptions.dart';
import 'package:fancy_dex/data/data_sources/pokemon_remote_data_source.dart';
import 'package:fancy_dex/data/entities/pokemon_entity.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'pokemon_json.dart';

class MockHttpClient extends Mock implements http.Client {}

main() {
  MockHttpClient mockHttpClient;
  PokemonRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    remoteDataSource = PokemonRemoteDataSourceImpl(client: mockHttpClient);
  });


  group('getPokemonByName', () {
    final pokemonName = "ditto";
    final pokemonEntity = PokemonEntity.fromJson(json.decode(pokemonJsonDitto));

    test('Should hit pokeapi to GET by Name (using json headers)', () async {
      //arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(pokemonJsonDitto, 200));
      //act
      remoteDataSource.getPokemonByName(pokemonName);
      //assert
      verify(mockHttpClient.get(
          'https://pokeapi.co/api/v2/pokemon/$pokemonName',
          headers: {'content-type': 'application/json'}));
    });

    test('should return a PokemonEntity when success', () async {
      //arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(pokemonJsonDitto, 200));

      //act
      final result = await remoteDataSource.getPokemonByName(pokemonName);

      //assert
      expect(result, equals(pokemonEntity));
    });

    test('should throw RemoteException when a 404 remote status code happen',
        () async {
      //arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Remote Error', 404));

      //act
      final getPokemonByName = remoteDataSource.getPokemonByName;

      //assert
      expect(
          () => getPokemonByName(pokemonName), throwsA(isA<RemoteException>()));
    });
  });

  group('getPokemonById', () {
    final pokemonId = 1;
    final pokemonEntity = PokemonEntity.fromJson(json.decode(pokemonJsonId1));

    test('Should hit pokeapi to GET by id (using json headers)', () async {
      //arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(pokemonJsonId1, 200));

      //act
      remoteDataSource.getPokemonById(pokemonId);

      //assert
      verify(mockHttpClient.get(
          'https://pokeapi.co/api/v2/pokemon/$pokemonId',
          headers: {'content-type': 'application/json'}));
    });

    test('should return a PokemonEntity when success', () async {
      //arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(pokemonJsonId1, 200));
      //act
      final result = await remoteDataSource.getPokemonById(pokemonId);
      //assert
      expect(result, equals(pokemonEntity));
    });

    test('should throw RemoteException when a 500 remote status code happen',
            () async {
          //arrange
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response('Remote Error', 500));

          //act
          final getPokemonById = remoteDataSource.getPokemonById;
          //assert
          expect(() => getPokemonById(pokemonId), throwsA(isA<RemoteException>()));
        });
  });



  group('getAllPaged', () {
    final offset = 0;
    final limit = 20;
    final result = json.decode(pokemonsJsonsOffset0Limit20)['results'] as Iterable;
    final pokemonsEntity = result.map((pokemonMap) => PokemonEntity.fromJson(pokemonMap)).toList();

    test('Should hit pokeapi to GET (all Paged) by offset + limit (using json headers)', () async {
      //arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(pokemonsJsonsOffset0Limit20, 200));

      //act
      remoteDataSource.getAllPaged(offset: offset, limit: limit);

      //assert
      verify(mockHttpClient.get(
          'https://pokeapi.co/api/v2/pokemon/?offset=$offset&limit=$limit',
          headers: {'content-type': 'application/json'}));
    });

    test('should return a pokemonsEntity when success', () async {
      //arrange
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(pokemonsJsonsOffset0Limit20, 200));
      //act
      final result = await remoteDataSource.getAllPaged(offset: offset,limit: limit);
      //assert
      expect(result, equals(pokemonsEntity));
    });

    test('should throw RemoteException when a 500 remote status code happen',
            () async {
          //arrange
          when(mockHttpClient.get(any, headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response('Remote Error', 500));

          //act
          final getAllPaged = remoteDataSource.getAllPaged;
          //assert
          expect(() => getAllPaged(offset:offset, limit:limit), throwsA(isA<RemoteException>()));
        });
  });
}
