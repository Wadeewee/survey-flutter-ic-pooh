import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

const String surveyBoxName = 'survey';

@module
abstract class DatabaseModule {
  @Singleton()
  @preResolve
  Future<Box> get surveyBox => Hive.openBox(surveyBoxName);
}
