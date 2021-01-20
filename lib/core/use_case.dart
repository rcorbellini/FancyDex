import 'package:dartz/dartz.dart';

abstract class UseCase<Output, Input> {
  Future<Either<Error, Output>> call({Input params});
}
