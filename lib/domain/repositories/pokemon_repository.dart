import 'package:dartz/dartz.dart';
import 'package:fancy_dex/core/errors.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';

abstract class PokemonRepository {
  Future<Either<Error, PokemonModel>> getPokemonByName(String name);
  Future<Either<Error, PokemonModel>> getPokemonById(int id);
  Future<Either<Error, PokemonModel>> getAllPaged(
      {int offset = 0, int limit = 20});
}
