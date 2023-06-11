import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:survey_flutter_ic/api/exception/network_exceptions.dart';
import 'package:survey_flutter_ic/api/persistence/auth_persistence.dart';
import 'package:survey_flutter_ic/api/repository/auth_repository.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';

@Injectable()
class SignOutUseCase extends NoParamsUseCase<void> {
  final AuthRepository _repository;
  final AuthPersistence _persistence;

  const SignOutUseCase(
    this._repository,
    this._persistence,
  );

  @override
  Future<Result<void>> call() async {
    final accessToken = await _persistence.accessToken ?? '';

    return _repository
        .signOut(token: accessToken)
        // ignore: unnecessary_cast
        .then((value) => Success(value) as Result<void>)
        .onError<NetworkExceptions>(
            (exception, stackTrace) => Failed(UseCaseException(exception)));
  }
}
