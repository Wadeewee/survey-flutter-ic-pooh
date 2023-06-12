import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:survey_flutter_ic/api/exception/network_exceptions.dart';
import 'package:survey_flutter_ic/usecase/base/base_use_case.dart';
import 'package:survey_flutter_ic/usecase/sign_out_use_case.dart';

import '../mocks/generate_mocks.mocks.dart';

void main() {
  group('SignOutUseCase', () {
    late MockAuthRepository mockRepository;
    late MockAuthPersistence mockAuthPersistence;
    late MockSurveyPersistence mockSurveyPersistence;
    late SignOutUseCase useCase;

    setUp(() {
      mockRepository = MockAuthRepository();
      mockAuthPersistence = MockAuthPersistence();
      mockSurveyPersistence = MockSurveyPersistence();
      useCase = SignOutUseCase(
          mockRepository, mockAuthPersistence, mockSurveyPersistence);

      when(mockAuthPersistence.accessToken)
          .thenAnswer((_) async => 'accessToken');
    });

    test('When calling SignOut successfully, it returns the result Success',
        () async {
      when(mockRepository.signOut(token: 'accessToken'))
          .thenAnswer((_) async => (null));
      when(mockAuthPersistence.clearAllStorage()).thenAnswer((_) async => {});
      when(mockSurveyPersistence.clear()).thenAnswer((_) async => {});

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

    test('When clear Persistence failed, it returns the result Failed',
        () async {
      when(mockAuthPersistence.clearAllStorage())
          .thenThrow(PlatformException(code: 'code'));
      when(mockSurveyPersistence.clear())
          .thenThrow(PlatformException(code: 'code'));

      final result = await useCase.call();

      expect(result, isA<Failed>());
      expect((result as Failed).exception.actualException,
          isA<PlatformException>());
    });
  });
}
