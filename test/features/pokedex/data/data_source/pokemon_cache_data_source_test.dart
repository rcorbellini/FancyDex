import 'dart:convert';

import 'package:fancy_dex/core/utils/sorted_cache_memory.dart';
import 'package:fancy_dex/features/pokedex/data/data_sources/pokemon_cache_data_source.dart';
import 'package:fancy_dex/features/pokedex/data/entities/pokemon_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'pokemon_json.dart';

class MemoryMock extends Mock implements SortedCacheMemory<PokemonEntity> {}

main() {
  PokemonCacheDataSourceImp localDataSource;
  MemoryMock memoryMock;

  setUp(() {
    memoryMock = MemoryMock();
    localDataSource = PokemonCacheDataSourceImp(memoryMock);
  });

  group('cacheDetailPokemon', () {
    final pokemonEntity = PokemonEntity.fromJson(json.decode(pokemonJsonDitto));

    test('Should add on memory when cacheDetail  called', () async {
      //arrange

      //act
      await localDataSource.cacheDetailPokemon(pokemonEntity);

      //assert
      verify(memoryMock.add(pokemonEntity));
    });

  });

  group('cachePokemons', () {
    final result =
        json.decode(pokemonsJsonsOffset0Limit20)['results'] as Iterable;
    final pokemonsEntity =
        result.map((pokemonMap) => PokemonEntity.fromJson(pokemonMap)).toList();

    test('Should addAll on memory when cachePokemons  called', () async {
      //arrange

      //act
      await localDataSource.cachePokemons(pokemonsEntity);

      //assert
      verify(memoryMock.addAll(pokemonsEntity));
    });

  });

  group('getCachedPokemonByName', () {
    final name = 'ditto';
    final pokemonEntity = PokemonEntity.fromJson(json.decode(pokemonJsonDitto));

    test('Should return the pokemonEntity when getCachedPokemonByName called',
        () async {
      //arrange
      when(memoryMock.firstWhere(any, orElse: anyNamed('orElse'))).thenAnswer((_) => pokemonEntity);
      when(memoryMock.where(any)).thenAnswer((_) => [pokemonEntity]);

      //act
      final result = await localDataSource.getCachedPokemonByName(name);

      //assert
      expect(result, equals(pokemonEntity));
    });

    test(
        'Should return null pokemonEntity when getCachedPokemonByName called with no cached pokemon',
        () async {
      //arrange

      //act
      final result = await localDataSource.getCachedPokemonByName(name);

      //assert
      expect(result, equals(null));
    });
  });

  group('getCachedPokemonById', () {
    final id = 1;
    final pokemonEntity = PokemonEntity.fromJson(json.decode(pokemonJsonDitto));

    test('Should return the pokemonEntity when getCachedPokemonById called',
        () async {
      //arrange
      when(memoryMock.firstWhere(any, orElse: anyNamed('orElse'))).thenAnswer((_) => pokemonEntity);
      when(memoryMock.where(any)).thenAnswer((_) => [pokemonEntity]);

      //act
      final result = await localDataSource.getCachedPokemonById(id);

      //assert
      expect(result, equals(pokemonEntity));
    });

    test(
        'Should return null pokemonEntity when getCachedPokemonById called with no cached pokemon',
        () async {
      //arrange

      //act
      final result = await localDataSource.getCachedPokemonById(id);

      //assert
      expect(result, equals(null));
    });
  });

  group('getCachedPokemons', () {
    final result =
        json.decode(pokemonsJsonsOffset0Limit20)['results'] as Iterable;
    final offset = 0;
    final limit = 20;
    final pokemonsEntity =
        result.map((pokemonMap) => PokemonEntity.fromJson(pokemonMap)).toList();

    test('Should return the pokemonsEntity when getCachedPokemons called',
        () async {
      //arrange
      when(memoryMock.where(any)).thenAnswer((_) => pokemonsEntity);

      //act
      final result =
          await localDataSource.getCachedPokemons(offset: offset, limit: limit);

      //assert
      expect(result, equals(pokemonsEntity));
    });

    test('Should return empty list when getCachedPokemons called with no cache',
        () async {
      //arrange

      //act
      final result =
          await localDataSource.getCachedPokemons(offset: offset, limit: limit);

      //assert
      expect(result.length, equals(0));
    });
  });
}
