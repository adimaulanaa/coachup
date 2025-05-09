import 'package:coachup/core/config/config_resources.dart';
import 'package:coachup/core/error/exceptions.dart';
import 'package:coachup/core/error/failure.dart';
import 'package:coachup/core/network/network_info.dart';
import 'package:coachup/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:coachup/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:coachup/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:dartz/dartz.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final DashboardLocalDataSource localDatasource;
  final NetworkInfo networkInfo;

  DashboardRepositoryImpl(
    this.remoteDataSource,
    this.localDatasource,
    this.networkInfo,
  );

  @override
  Future<Either<Failure, String>> getDash(
      String entity) async {
    if (await networkInfo.isConnected) {
      try {
        final local = await localDatasource.getDash(entity);
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
