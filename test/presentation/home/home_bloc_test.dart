import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fancy_dex/data/entities/pokemon_entity.dart';
import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';
import 'package:fancy_dex/presentation/home/bloc/home_bloc.dart';
import 'package:fancy_dex/presentation/home/bloc/home_event.dart';
import 'package:fancy_dex/presentation/home/bloc/home_status.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../data/data_source/pokemon_json.dart';

class PokemonRepositoryMock extends Mock implements PokemonRepository {}

class FancyMock extends Mock implements Fancy {}

void main() {
  PokemonRepositoryMock pokemonRepositoryMock;
  FancyMock fancyMock;
  HomeBloc homeBloc;

  setUp(() {
    fancyMock = FancyMock();
    pokemonRepositoryMock = PokemonRepositoryMock();
    homeBloc =
        HomeBloc(pokemonRepository: pokemonRepositoryMock, fancy: fancyMock);
  });

  test('should call handleEvent when event are dispatched', () async {
    //arrange
    final evt = PokemonRandom();
    //act
    homeBloc.dispatchOn(evt);
    //assert
    verify(homeBloc.dispatchOn(evt));
  });

  test('when dispatched a event for random pokemon, repository must be called',
      () async {
    //arrange
    final evt = PokemonRandom();
    final stream = homeBloc.streamOf<HomeStatus>();
    final pokemonEntity = PokemonEntity.fromJson(json.decode(pokemonJsonDitto));

    when(pokemonRepositoryMock.getRandomPokemon())
        .thenAnswer((_) async => Right(pokemonEntity));

    //act
    homeBloc.dispatchOn<HomeEvent>(evt);

    //assert
    verify(pokemonRepositoryMock.getRandomPokemon());
    expect(stream, emitsInOrder([ListLoading(), ListLoaded(any)]));
  });

  test('when dispatched a event for named pokemon, repository must be called',
      () async {
    //arrange
    final name = "ditto";
    final evt = PokemonByName(name);
    final stream = homeBloc.streamOf<HomeStatus>();
    final pokemonEntity = PokemonEntity.fromJson(json.decode(pokemonJsonDitto));
    when(pokemonRepositoryMock.getPokemonByName(name))
        .thenAnswer((_) async => Right(pokemonEntity));

    //act
    homeBloc.dispatchOn<HomeEvent>(evt);

    //assert
    verify(pokemonRepositoryMock.getPokemonByName(name));
    expect(stream, emitsInOrder([ListLoading(), ListLoaded(any)]));
  });

  test(
      'when dispatched a event for loadMore pokemon, repository must be called',
      () async {
    //arrange=
    final evt = LoadMore();
    final stream = homeBloc.streamOf<HomeStatus>();

    final result =
    json.decode(pokemonsJsonsOffset0Limit20)['results'] as Iterable;
    final pokemonsEntity =
    result.map((pokemonMap) => PokemonEntity.fromJson(pokemonMap)).toList();

    when(pokemonRepositoryMock.getAllPaged(
        offset: anyNamed('offset'), limit: anyNamed('limit')))
        .thenAnswer((_) async => Right(pokemonsEntity));

    //act
    homeBloc.dispatchOn<HomeEvent>(evt);

    //assert
    verify(pokemonRepositoryMock.getAllPaged(
        offset: anyNamed('offset'), limit: anyNamed('limit')));
    expect(stream, emitsInOrder([ListLoading(), ListLoaded(any)]));
  });
}
