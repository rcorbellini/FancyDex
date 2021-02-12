import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fancy_dex/core/errors/errors.dart';
import 'package:fancy_dex/features/pokedex/data/entities/pokemon_entity.dart';
import 'package:fancy_dex/features/pokedex/domain/repositories/pokemon_repository.dart';
import 'package:fancy_dex/features/pokedex/domain/use_cases/get_all_pokemon_use_case.dart';
import 'package:fancy_dex/features/pokedex/domain/use_cases/get_pokemon_use_case.dart';
import 'package:fancy_dex/features/pokedex/presentation/detail/bloc/detail_status.dart';
import 'package:fancy_dex/features/pokedex/presentation/home/bloc/home_bloc.dart';
import 'package:fancy_dex/features/pokedex/presentation/home/bloc/home_event.dart';
import 'package:fancy_dex/features/pokedex/presentation/home/bloc/home_status.dart';
import 'package:fancy_dex/features/pokedex/presentation/shared/models/pokemon_presentation.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/data_source/pokemon_json.dart';

class PokemonRepositoryMock extends Mock implements PokemonRepository {}

class GetPokemonUseCaseMock extends Mock implements GetPokemonUseCase {}

class GetAllPokemonUseCaseMock extends Mock implements GetAllPokemonUseCase {}

class FancyMock extends Mock implements Fancy {}

class StreamMock<T> extends Mock implements ValueStream<T> {}

///init already test in base bloc
class HomeBlocByPassInit extends HomeBloc {
  HomeBlocByPassInit(
      {GetPokemonUseCase getPokemonUseCase,
      GetAllPokemonUseCase getAllPokemonUseCase,
      Fancy fancy})
      : super(
            getPokemonUseCase: getPokemonUseCase,
            getAllPokemonUseCase: getAllPokemonUseCase,
            fancy: fancy);

  @override
  void init() {
    ///do nothing here
  }
}

void main() {
  GetPokemonUseCaseMock getPokemonUseCaseMock;
  GetAllPokemonUseCaseMock getAllPokemonUseCaseMock;
  FancyMock fancyMock;
  HomeBloc homeBloc;
  StreamMock<HomeEvent> stream;

  setUp(() {
    fancyMock = FancyMock();
    getPokemonUseCaseMock = GetPokemonUseCaseMock();
    getAllPokemonUseCaseMock = GetAllPokemonUseCaseMock();
    stream = StreamMock<HomeEvent>();

    homeBloc = HomeBlocByPassInit(
        getPokemonUseCase: getPokemonUseCaseMock,
        getAllPokemonUseCase: getAllPokemonUseCaseMock,
        fancy: fancyMock);
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
      when(getPokemonUseCaseMock.call(params: anyNamed('params')))
          .thenAnswer((_) async => Right(pokemonEntity));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verify(getPokemonUseCaseMock.call(params: anyNamed('params')));
    });

    test(
        'when dispatched event, loading + loaded must be dispatched (with repository success)',
        () async {
      //arrange
      when(fancyMock.map).thenAnswer(
          (realInvocation) => <String, dynamic>{statusKey: statusList});
      when(getPokemonUseCaseMock.call(params: anyNamed('params')))
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
      when(getPokemonUseCaseMock.call(params: anyNamed('params')))
          .thenAnswer((_) async => Left(RemoteError()));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verify(getPokemonUseCaseMock.call(params: anyNamed('params')));
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
      when(getPokemonUseCaseMock.call(params: anyNamed('params')))
          .thenAnswer((_) async => Right(pokemonEntity));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verify(getPokemonUseCaseMock.call(params: anyNamed('params')));
    });

    test(
        'when dispatched event, loading + loaded must be dispatched (with repository success)',
        () async {
      //arrange
      when(fancyMock.map).thenAnswer(
          (realInvocation) => <String, dynamic>{statusKey: statusList});
      when(getPokemonUseCaseMock.call(params: anyNamed('params')))
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
      when(getPokemonUseCaseMock.call(params: anyNamed('params')))
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
    final statusTypesFiltered = 'types_filtered';

    test('when dispatched event, repository must be called', () async {
      //arrange
      when(fancyMock.map).thenAnswer((realInvocation) => <String, dynamic>{
            statusKey: statusList,
            statusTypesFiltered: <String>[]
          });
      when(getAllPokemonUseCaseMock.call(params: anyNamed('params')))
          .thenAnswer((_) async => Right(pokemonsEntity));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verify(getAllPokemonUseCaseMock.call(params: anyNamed('params')));
    });

    test(
        'when dispatched event, loading + loaded must be dispatched (with repository success)',
        () async {
      //arrange
      when(fancyMock.map).thenAnswer((realInvocation) => <String, dynamic>{
            statusKey: statusList,
            statusTypesFiltered: <String>[]
          });
      when(getAllPokemonUseCaseMock.call(params: anyNamed('params')))
          .thenAnswer((_) async => Right(pokemonsEntity));

      //act
      await homeBloc.handleEvents(evt);

      //assert
      verifyInOrder([
        fancyMock.dispatchOn<HomeStatus>(
            ListLoading(lastPokemonsLoaded: pokemonsPresentation),
            key: statusKey),
        //TODO
        //fancyMock.dispatchOn<HomeStatus>(ListLoaded(pokemonsPresentation),
        //    key: statusKey)
      ]);
    });

    test(
        'when dispatched event, list loading + error must be dispatched (with repository error)',
        () async {
      //arrange
      when(fancyMock.map).thenAnswer((realInvocation) => <String, dynamic>{
            statusKey: statusList,
            statusTypesFiltered: <String>[]
          });
      when(getAllPokemonUseCaseMock.call(params: anyNamed('params')))
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
