import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/error/exceptions.dart';
import 'package:coachup/core/error/failure.dart';
import 'package:coachup/core/network/network_info.dart';
import 'package:coachup/features/students/data/datasources/students_local_datasource.dart';
import 'package:coachup/features/students/data/datasources/students_remote_datasource.dart';
import 'package:coachup/features/students/domain/entities/students_entity.dart';
import 'package:coachup/features/students/domain/repositories/students_repository.dart';
import 'package:dartz/dartz.dart';

class StudentsRepositoryImpl implements StudentsRepository {
  final StudentsRemoteDataSource remoteDataSource;
  final StudentsLocalDataSource localDatasource;
  final NetworkInfo networkInfo;

  StudentsRepositoryImpl(
    this.remoteDataSource,
    this.localDatasource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, String>> createStudents(StudentEntity entity) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.insertStudents(entity);
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
  Future<Either<Failure, List<StudentEntity>>> list() async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.list();
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
  Future<Either<Failure, StudentEntity>> get(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.get(id);
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
  Future<Either<Failure, String>> updateStudents(StudentEntity entity) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.updateStudents(entity);
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
  Future<Either<Failure, String>> deleteStudents(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.deleteStudents(id);
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
