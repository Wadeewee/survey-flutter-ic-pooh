import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey_flutter_ic/api/exception/network_exceptions.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';
import 'package:survey_flutter_ic/usecase/sign_out_use_case.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group('SignOutUseCase', () {
    late MockAuthRepository mockRepository;
    late MockAuthPersistence mockPersistence;
    late SignOutUseCase useCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      mockPersistence = MockAuthPersistence();
      useCase = SignOutUseCase(mockRepository, mockPersistence);

      when(mockPersistence.accessToken).thenAnswer((_) async => 'accessToken');
    });

    test('When calling SignOut successfully, it returns the result Success',
        () async {
      when(mockRepository.signOut(token: 'accessToken'))
          .thenAnswer((_) async => (null));

      final result = await useCase.call();

      expect(result, isA<Success>());
    });

    test('When calling SignOut failed, it returns the result Failed', () async {
      const exception = NetworkExceptions.unexpectedError();
      when(mockRepository.signOut(token: 'accessToken'))
          .thenAnswer((_) => Future.error(exception));

      final result = await useCase.call();

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException, exception);
    });
  });
}