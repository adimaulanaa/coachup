import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/error/exceptions.dart';
import 'package:coachup/core/error/failure.dart';
import 'package:coachup/core/network/network_info.dart';
import 'package:coachup/features/privates/data/datasources/privates_local_datasource.dart';
import 'package:coachup/features/privates/data/datasources/privates_remote_datasource.dart';
import 'package:coachup/features/privates/data/models/privates_model.dart';
import 'package:coachup/features/privates/domain/entities/privates_entity.dart';
import 'package:coachup/features/privates/domain/repositories/privates_repository.dart';
import 'package:dartz/dartz.dart';

class PrivatesRepositoryImpl implements PrivatesRepository {
  final PrivatesRemoteDataSource remoteDataSource;
  final PrivatesLocalDataSource localDatasource;
  final NetworkInfo networkInfo;

  PrivatesRepositoryImpl(
    this.remoteDataSource,
    this.localDatasource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, List<PrivatesModel>>> list(
      String str, String fns) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.list(str, fns);
        return Right(local);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException {
        return const Left(
            NetworkFailure(StringResources.networkFailureMessage));
      }
    } else {
      return const Left(
          NetworkFailure(StringResources.networkFailureMessage));
    }
  }

  @override
  Future<Either<Failure, PrivatesModel>> get(
      String id) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.get(id);
        return Right(local);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException {
        return const Left(
            NetworkFailure(StringResources.networkFailureMessage));
      }
    } else {
      return const Left(
          NetworkFailure(StringResources.networkFailureMessage));
    }
  }

  @override
  Future<Either<Failure, String>> created(PrivatesEntity entity) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.create(entity);
        return Right(local);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException {
        return const Left(
            NetworkFailure(StringResources.networkFailureMessage));
      }
    } else {
      return const Left(
          NetworkFailure(StringResources.networkFailureMessage));
    }
  }
  
  @override
  Future<Either<Failure, String>> delete(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.delete(id);
        return Right(local);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException {
        return const Left(
            NetworkFailure(StringResources.networkFailureMessage));
      }
    } else {
      return const Left(
          NetworkFailure(StringResources.networkFailureMessage));
    }
  }
  
  @override
  Future<Either<Failure, String>> updated(PrivatesEntity entity) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.update(entity);
        return Right(local);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException {
        return const Left(
            NetworkFailure(StringResources.networkFailureMessage));
      }
    } else {
      return const Left(
          NetworkFailure(StringResources.networkFailureMessage));
    }
  }
  
  @override
  Future<Either<Failure, List<String>>> listMurid() async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.listMurid();
        return Right(local);
      } on BadRequestException catch (e) {
        return Left(BadRequestFailure(e.toString()));
      } on UnauthorisedException catch (e) {
        return Left(UnauthorisedFailure(e.toString()));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.toString()));
      } on FetchDataException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on InvalidCredentialException catch (e) {
        return Left(InvalidCredentialFailure(e.toString()));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message ?? ''));
      } on NetworkException {
        return const Left(
            NetworkFailure(StringResources.networkFailureMessage));
      }
    } else {
      return const Left(
          NetworkFailure(StringResources.networkFailureMessage));
    }
  }
}
