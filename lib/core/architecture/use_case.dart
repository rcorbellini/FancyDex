import 'package:dartz/dartz.dart';
import 'package:fancy_dex/core/errors/errors.dart';

abstract class UseCase<Input, Output> {
  Future<Either<Error, Output>> call({Input params});
}
