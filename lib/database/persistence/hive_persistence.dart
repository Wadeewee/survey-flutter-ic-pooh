import 'package:hive_flutter/hive_flutter.dart';
import 'package:survey_flutter_ic/database/dto/survey_dto.dart';

Future<void> initHivePersistence() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SurveyDtoAdapter());
}
