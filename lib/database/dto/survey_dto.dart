import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:survey_flutter_ic/model/survey_model.dart';

part 'survey_dto.g.dart';

@HiveType(typeId: 0)
class SurveyDto extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final bool isActive;
  @HiveField(4)
  final String coverImageUrl;
  @HiveField(5)
  final String largeCoverImageUrl;
  @HiveField(6)
  final String createdAt;
  @HiveField(7)
  final String surveyType;

  const SurveyDto({
    required this.id,
    required this.title,
    required this.description,
    required this.isActive,
    required this.coverImageUrl,
    required this.largeCoverImageUrl,
    required this.createdAt,
    required this.surveyType,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isActive,
        coverImageUrl,
        largeCoverImageUrl,
        createdAt,
        surveyType,
      ];

  factory SurveyDto.fromModel(SurveyModel model) {
    return SurveyDto(
      id: model.id,
      title: model.title,
      description: model.description,
      isActive: model.isActive,
      coverImageUrl: model.coverImageUrl,
      largeCoverImageUrl: model.largeCoverImageUrl,
      createdAt: model.createdAt,
      surveyType: model.surveyType,
    );
  }
}
