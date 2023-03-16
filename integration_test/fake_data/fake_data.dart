import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../utils/file_util.dart';

class FakeResponseModel extends Equatable {
  final int statusCode;
  final Map<String, dynamic> json;

  const FakeResponseModel(
    this.statusCode,
    this.json,
  );

  @override
  List<Object?> get props => [
        statusCode,
        json,
      ];
}

const String keySignIn = 'signIn';

class FakeData {
  FakeData._();

  static final Map<String, FakeResponseModel> _apiAndResponse = {};

  static Map<String, FakeResponseModel> get apiAndResponse => _apiAndResponse;

  static Future<void> initDefault() async {
    _apiAndResponse.addAll({
      keySignIn: FakeResponseModel(
        200,
        await FileUtil.loadFile(
            'integration_test/fake_data/sign_in_response.json'),
      ),
    });
  }

  static void updateResponse(String key, FakeResponseModel newValue) {
    _apiAndResponse.update(
      key,
      (value) => newValue,
      ifAbsent: () => newValue,
    );
  }
}

DioError generateDioError(int statusCode) {
  return DioError(
    response: Response(
      statusCode: statusCode,
      requestOptions: RequestOptions(path: ''),
    ),
    type: DioErrorType.badResponse,
    requestOptions: RequestOptions(path: ''),
  );
}
