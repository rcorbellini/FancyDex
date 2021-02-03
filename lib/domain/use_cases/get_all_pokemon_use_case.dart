import 'package:dartz/dartz.dart';
import 'package:fancy_dex/core/errors/errors.dart';
import 'package:fancy_dex/core/architecture/use_case.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';

class GetAllPokemonUseCase
    extends UseCase<ParamGetAllPokemonPagged, List<PokemonModel>> {
  final PokemonRepository pokemonRepository;

  GetAllPokemonUseCase(this.pokemonRepository);

  @override
  Future<Either<Error, List<PokemonModel>>> call(
      {ParamGetAllPokemonPagged params =  const ParamGetAllPokemonPagged()}) {
    return pokemonRepository.getAllPaged(
        offset: params?.offset, limit: params?.limit);
  }
}

class ParamGetAllPokemonPagged {
  final int offset;
  final int limit;

  const ParamGetAllPokemonPagged({this.offset = 0, this.limit = 20});
}
