import 'package:converse/core/failure.dart';
import 'package:fpdart/fpdart.dart';

// FutureEither<UserModel>
// T to give any type
typedef FutureEither<T> = Future<Either<Failure, T>>;

typedef FutureVoid = FutureEither<void>;
