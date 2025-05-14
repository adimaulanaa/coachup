import 'package:coachup/core/error/failure.dart';
import 'package:coachup/features/profile/domain/entities/profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProf();
  Future<Either<Failure, String>> updateProfile(ProfileEntity entity);
}