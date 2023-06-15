import 'package:equatable/equatable.dart';
import 'package:survey_flutter_ic/api/response/profile_response.dart';

class ProfileModel extends Equatable {
  final String avatarUrl;
  final String name;

  const ProfileModel({
    required this.avatarUrl,
    required this.name,
  });

  @override
  List<Object?> get props => [
        avatarUrl,
        name,
      ];

  factory ProfileModel.fromResponse(ProfileResponse response) {
    return ProfileModel(
      avatarUrl: response.avatarUrl,
      name: response.name,
    );
  }
}
