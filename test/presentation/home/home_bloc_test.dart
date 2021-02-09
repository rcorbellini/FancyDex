import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fancy_dex/core/errors/errors.dart';
import 'package:fancy_dex/data/entities/pokemon_entity.dart';
import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';
import 'package:fancy_dex/presentation/home/bloc/home_bloc.dart';
import 'package:fancy_dex/presentation/home/bloc/home_event.dart';
import 'package:fancy_dex/presentation/home/bloc/home_status.dart';
import 'package:fancy_dex/presentation/models/pokemon_presentation.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/data_source/pokemon_json.dart';

class PokemonRepositoryMock extends Mock implements PokemonRepository {}

class FancyMock extends Mock implements Fancy {}

class StreamMock<T> extends Mock implements ValueStream<T> {}

///init already test in base bloc
class HomeBlocByPassInit extends HomeBloc {
  HomeBlocByPassInit({PokemonRepository pokemonRepository, Fancy fancy})
      : super(pokemonRepository: pokemonRepository, fancy: fancy);

  @override
  void init() {
    ///do nothing here
  }
}

void main() {
  PokemonRepositoryMock pokemonRepositoryMock;
  FancyMock fancyMock;
  HomeBloc homeBloc;
  StreamMock<HomeEvent> stream;

  setUp(() {
    fancyMock = FancyMock();
    stream = StreamMock<HomeEvent>();
    pokemonRepositoryMock = PokemonRepositoryMock();

    homeBloc = HomeBlocByPassInit(
        pokemonRepository: pokemonRepositoryMock, fancy: fancyMock);
  });

  test('should call handleEvent when event are dispatched', () async {
    //arrange
    final evt = RandomPokemon();

    //act
    homeBloc.dispatchOn(evt);

    //assert
    verify(fancyMock.dispatchOn(evt));
  });

  group('PokemonRandom evt:', () {
    final evt = RandomPokemon();
    final pokemonEntity = PokemonEntity.fromJson(json.decode(pokemonJsonDitto));
    final pokemonPresentation = PokemonPresentation.fromModel(pokemonEntity);
    final pokemonsPresentation = [pokemonPresentation];
    final statusList = ListLoaded(pokemonsPresentation);
    final statusKey = 'status';

    test('when dispatched event, repository must be called', () async {
      //arrange
      when(fancyMock.map).thenAnswer(
          (realInvocation) => <String, dynamic>{statusKey: statusList});
      when(pokemonRepositoryMock.getRandomPokemon())
          .thenAnswer((_) async => Right(pokemonEntity));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verify(pokemonRepositoryMock.getRandomPokemon());
    });

    test(
        'when dispatched event, loading + loaded must be dispatched (with repository success)',
        () async {
      //arrange
      when(fancyMock.map).thenAnswer(
          (realInvocation) => <String, dynamic>{statusKey: statusList});
      when(pokemonRepositoryMock.getRandomPokemon())
          .thenAnswer((_) async => Right(pokemonEntity));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verifyInOrder([
        fancyMock.dispatchOn<HomeStatus>(
            ListLoading(lastPokemonsLoaded: pokemonsPresentation),
            key: anyNamed('key')),
        fancyMock.dispatchOn<HomeStatus>(PokemonFound(pokemonPresentation),
            key: anyNamed('key'))
      ]);
    });

    test(
        'when dispatched event, list loading + error must be dispatched (with repository error)',
        () async {
      //arrange
      when(fancyMock.map).thenAnswer(
          (realInvocation) => <String, dynamic>{statusKey: statusList});
      when(pokemonRepositoryMock.getRandomPokemon())
          .thenAnswer((_) async => Left(RemoteError()));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verify(pokemonRepositoryMock.getRandomPokemon());
      verifyInOrder([
        fancyMock.dispatchOn<HomeStatus>(
            ListLoading(lastPokemonsLoaded: pokemonsPresentation),
            key: anyNamed('key')),
        fancyMock.dispatchOn<HomeStatus>(
            ListError(lastPokemonsLoaded: pokemonsPresentation),
            key: anyNamed('key'))
      ]);
    });
  });

  group('PokemonByName evt:', () {
    final name = 'ditto';
    final evt = LoadPokemonByNameOrId(name);
    final pokemonEntity = PokemonEntity.fromJson(json.decode(pokemonJsonDitto));
    final pokemonPresentation = PokemonPresentation.fromModel(pokemonEntity);
    final pokemonsPresentation = [pokemonPresentation];
    final statusList = ListLoaded(pokemonsPresentation);
    final statusKey = 'status';

    test('when dispatched event, repository must be called', () async {
      //arrange
      when(fancyMock.map).thenAnswer(
          (realInvocation) => <String, dynamic>{statusKey: statusList});
      when(pokemonRepositoryMock.getPokemonByName(name))
          .thenAnswer((_) async => Right(pokemonEntity));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verify(pokemonRepositoryMock.getPokemonByName(name));
    });

    test(
        'when dispatched event, loading + loaded must be dispatched (with repository success)',
        () async {
      //arrange
      when(fancyMock.map).thenAnswer(
          (realInvocation) => <String, dynamic>{statusKey: statusList});
      when(pokemonRepositoryMock.getPokemonByName(name))
          .thenAnswer((_) async => Right(pokemonEntity));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verifyInOrder([
        fancyMock.dispatchOn<HomeStatus>(
            ListLoading(lastPokemonsLoaded: pokemonsPresentation),
            key: anyNamed('key')),
        fancyMock.dispatchOn<HomeStatus>(PokemonFound(pokemonPresentation),
            key: anyNamed('key'))
      ]);
    });

    test(
        'when dispatched event, list loading + error must be dispatched (with repository error)',
        () async {
      //arrange
      when(fancyMock.map).thenAnswer(
          (realInvocation) => <String, dynamic>{statusKey: statusList});
      when(pokemonRepositoryMock.getPokemonByName(name))
          .thenAnswer((_) async => Left(RemoteError()));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verifyInOrder([
        fancyMock.dispatchOn<HomeStatus>(
            ListLoading(lastPokemonsLoaded: pokemonsPresentation),
            key: anyNamed('key')),
        fancyMock.dispatchOn<HomeStatus>(
            ListError(lastPokemonsLoaded: pokemonsPresentation),
            key: anyNamed('key'))
      ]);
    });
  });

  group('LoadMore evt:', () {
    final evt = LoadMorePokemons();
    final result =
        json.decode(pokemonsJsonsOffset0Limit20)['results'] as Iterable;
    final pokemonsEntity =
        result.map((pokemonMap) => PokemonEntity.fromJson(pokemonMap)).toList();
    final pokemonsPresentation = pokemonsEntity
        .map((pokemonModel) => PokemonPresentation.fromModel(pokemonModel))
        .toList();
    final statusList = ListLoaded(pokemonsPresentation);
    final statusKey = 'status';

    test('when dispatched event, repository must be called', () async {
      //arrange
      when(fancyMock.map).thenAnswer(
          (realInvocation) => <String, dynamic>{statusKey: statusList});
      when(pokemonRepositoryMock.getAllPaged(
              offset: anyNamed('offset'), limit: anyNamed('limit')))
          .thenAnswer((_) async => Right(pokemonsEntity));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verify(pokemonRepositoryMock.getAllPaged(
          offset: anyNamed('offset'), limit: anyNamed('limit')));
    });

    test(
        'when dispatched event, loading + loaded must be dispatched (with repository success)',
        () async {
      //arrange
      when(fancyMock.map).thenAnswer(
          (realInvocation) => <String, dynamic>{statusKey: statusList});
      when(pokemonRepositoryMock.getAllPaged(
              offset: anyNamed('offset'), limit: anyNamed('limit')))
          .thenAnswer((_) async => Right(pokemonsEntity));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verifyInOrder([
        fancyMock.listenOn(homeBloc.handleEvents),
        fancyMock.dispatchOn<HomeStatus>(ListLoading()),
        fancyMock.dispatchOn<HomeStatus>(ListLoaded(pokemonsPresentation))
      ]);
    });

    test(
        'when dispatched event, list loading + error must be dispatched (with repository error)',
        () async {
      //arrange
      when(fancyMock.map).thenAnswer(
          (realInvocation) => <String, dynamic>{statusKey: statusList});
      when(pokemonRepositoryMock.getAllPaged(
              offset: anyNamed('offset'), limit: anyNamed('limit')))
          .thenAnswer((_) async => Left(RemoteError()));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verifyInOrder([
        fancyMock.dispatchOn<HomeStatus>(
            ListLoading(lastPokemonsLoaded: pokemonsPresentation),
            key: anyNamed('key')),
        fancyMock.dispatchOn<HomeStatus>(
            ListError(lastPokemonsLoaded: pokemonsPresentation),
            key: anyNamed('key'))
      ]);
    });
  });
}
