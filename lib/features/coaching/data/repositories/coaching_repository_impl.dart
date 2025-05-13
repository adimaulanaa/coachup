import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/error/exceptions.dart';
import 'package:coachup/core/error/failure.dart';
import 'package:coachup/core/network/network_info.dart';
import 'package:coachup/features/coaching/data/datasources/coaching_local_datasource.dart';
import 'package:coachup/features/coaching/data/datasources/coaching_remote_datasource.dart';
import 'package:coachup/features/coaching/domain/entities/coaching_entity.dart';
import 'package:coachup/features/coaching/domain/repositories/coaching_repository.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:dartz/dartz.dart';

class CoachingRepositoryImpl implements CoachingRepository {
  final CoachingRemoteDataSource remoteDataSource;
  final CoachingLocalDataSource localDatasource;
  final NetworkInfo networkInfo;

  CoachingRepositoryImpl(
    this.remoteDataSource,
    this.localDatasource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, String>> createCoaching(CoachEntity entity) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.insertCoaching(entity);
        return Right(local);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.message));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.message));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException {
        return const Left(
            NetworkFailure(StringResources.networkFailureMessage));
      }
    } else {
      return const Left(NetworkFailure(StringResources.networkFailureMessage));
    }
  }

  @override
  Future<Either<Failure, List<CoachEntity>>> getCoachings() async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.getCoaching();
        return Right(local);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.message));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.message));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException {
        return const Left(
            NetworkFailure(StringResources.networkFailureMessage));
      }
    } else {
      return const Left(NetworkFailure(StringResources.networkFailureMessage));
    }
  }

  @override
  Future<Either<Failure, String>> updateCoaching(CoachEntity entity) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.updateCoaching(entity);
        return Right(local);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.message));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.message));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException {
        return const Left(
            NetworkFailure(StringResources.networkFailureMessage));
      }
    } else {
      return const Left(NetworkFailure(StringResources.networkFailureMessage));
    }
  }

  @override
  Future<Either<Failure, String>> deleteCoaching(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.deleteCoaching(id);
        return Right(local);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.message));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.message));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException {
        return const Left(
            NetworkFailure(StringResources.networkFailureMessage));
      }
    } else {
      return const Left(NetworkFailure(StringResources.networkFailureMessage));
    }
  }

  @override
  Future<Either<Failure, List<StudentEntity>>> getStudentc() async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.getStudentc();
        return Right(local);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.message));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.message));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException {
        return const Left(
            NetworkFailure(StringResources.networkFailureMessage));
      }
    } else {
      return const Left(NetworkFailure(StringResources.networkFailureMessage));
    }
  }
}
