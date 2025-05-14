import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/error/exceptions.dart';
import 'package:coachup/core/error/failure.dart';
import 'package:coachup/core/network/network_info.dart';
import 'package:coachup/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:coachup/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:coachup/features/profile/domain/entities/profile_entity.dart';
import 'package:coachup/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDatasource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl(
    this.remoteDataSource,
    this.localDatasource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, ProfileEntity>> getProf(
      ) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.getProf();
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
  Future<Either<Failure, String>> updateProfile(ProfileEntity entity) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.updateProfile(entity);
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
