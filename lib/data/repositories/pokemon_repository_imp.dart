import 'package:dartz/dartz.dart';
import 'package:fancy_dex/core/errors.dart';
import 'package:fancy_dex/domain/models/pokemon_model.dart';
import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImp extends PokemonRepository{

  @override
  Future<Either<Error, List<PokemonModel>>> getAllPaged({int offset = 0, int limit = 20}) {
    // TODO: implement getAllPaged
    throw UnimplementedError();
  }

  @override
  Future<Either<Error, PokemonModel>> getPokemonById(int id) {
    // TODO: implement getPokemonById
    throw UnimplementedError();
  }

  @override
  Future<Either<Error, PokemonModel>> getPokemonByName(String name) {
    // TODO: implement getPokemonByName
    throw UnimplementedError();
  }

}