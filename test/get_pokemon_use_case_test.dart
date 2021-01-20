
import 'package:dartz/dartz.dart';
import 'package:fancy_dex/core/use_case.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  GetPokemonUseCase getPokemonUseCase;
  MockPokemonRepository mockPokemonRepository;

  setUp(() {
    mockPokemonRepository = MockPokemonRepository();
    getPokemonUseCase = GetPokemonUseCase(mockPokemonRepository);
  });


  test('should use repository.getPokemonByName to get pokemon by name',
          () async {
        //->arrange
        final PokemonModel pokemonMock = null;
        final Filter filter =  Filter(pokemonName : "Ditto");
        when(mockPokemonRepository.getPokemonByName(any))
            .thenAnswer((_) async => Right(pokemonMock));

        //->act
        final result = await getPokemonUseCase.call(filter: filter);

        //->assert
        expect(result, Right(pokemonMock));

        verify(mockPokemonRepository.getPokemonByName(pokemonName));
        verifyNoMoreInteractions(mockPokemonRepository);
      });

  test('should use repository.getPokemonById to get pokemon by id',
          () async {
        //->arrange
        final PokemonModel pokemonMock = null;
        final Filter filter =  Filter(id : 1);
        when(mockPokemonRepository.getPokemonById(any))
            .thenAnswer((_) async => Right(pokemonMock));

        //->act
        final result = await getPokemonUseCase.call(filter: filter);

        //->assert
        expect(result, Right(pokemonMock));

        verify(mockPokemonRepository.getPokemonByName(pokemonName));
        verifyNoMoreInteractions(mockPokemonRepository);
      });

  test('Filter must be send',
          () async {
        //->arrange

        //->act
        final result = await getPokemonUseCase.call();

        //->assert
        expect(() {
          assert(false);
        }, throwsAssertionError);
      });


  test('Filter must have either name, id.',
          () async {
        //->arrange
        final Filter filter =  Filter();

        //->act
        final result = await getPokemonUseCase.call(filter : filter);

        //->assert
        expect(() {
          assert(false);
        }, throwsAssertionError);
      });
}
