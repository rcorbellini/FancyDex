import 'package:dartz/dartz.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';

abstract class PokemonRepository {
  Future<Either<int, PokemonModel>> getPokemonByName(String name);
  Future<Either<int, PokemonModel>> getPokemonById(int id);
  Future<Either<int, PokemonModel>> getAllPaged(
      {int offset = 0, int limit = 20});
}
