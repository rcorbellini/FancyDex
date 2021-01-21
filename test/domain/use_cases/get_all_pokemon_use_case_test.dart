import 'package:dartz/dartz.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';
import 'package:fancy_dex/domain/use_cases/get_all_pokemon_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  GetAllPokemonUseCase getPokemonUseCase;
  MockPokemonRepository mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    getPokemonUseCase = GetAllPokemonUseCase(mockPokemonRepository);
  });

  test(
      'should use repository.getAllPaged to get all pokemon [pagged] with no parameters',
      () async {
    //->arrange
    final List<PokemonModel> pokemonsMock = List.empty();
    when(mockPokemonRepository.getAllPaged())
        .thenAnswer((_) async => Right(pokemonsMock));

    //->act
    final result = await getPokemonUseCase.call();

    //->assert
    expect(result, Right(pokemonsMock));

    verify(mockPokemonRepository.getAllPaged());
    verifyNoMoreInteractions(mockPokemonRepository);
  });

  test(
      'should use repository.getAllPaged to get all pokemon [pagged] with parameters',
      () async {
    //->arrange
    final List<PokemonModel> pokemonsMock = List.empty();
    final ParamGetAllPokemonPagged params =
        ParamGetAllPokemonPagged(offset: 10, limit: 20);
    when(mockPokemonRepository.getAllPaged(offset: any, limit: any))
        .thenAnswer((_) async => Right(pokemonsMock));

    //->act
    final result = await getPokemonUseCase.call();

    //->assert
    expect(result, Right(pokemonsMock));

    verify(mockPokemonRepository.getAllPaged(offset: 10, limit: 20));
    verifyNoMoreInteractions(mockPokemonRepository);
  });
}
