import 'package:dartz/dartz.dart';
import 'package:college_community_mobileapp/core/error/failure.dart'; // Custom Failure class
import 'package:college_community_mobileapp/features/auth/data/data_source/local_datasource/auth_local_datasource.dart'; // Local DataSource
import 'package:college_community_mobileapp/features/auth/domain/entity/auth_entity.dart'; // AuthEntity
import 'package:college_community_mobileapp/features/auth/domain/repository/auth_repository.dart'; // AuthRepository interface

class AuthLocalRepository implements AuthRepository {
  final AuthLocalDataSource _authLocalDataSource;

  // Constructor injecting the local data source
  AuthLocalRepository(this._authLocalDataSource);

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final currentUser = await _authLocalDataSource.getCurrentUser();
      return Right(currentUser);
    } catch (e) {
      // Return failure if something goes wrong
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> loginUser(String email, String password) async {
    try {
      // Attempt to login and get a token from the local data source
      final token = await _authLocalDataSource.loginUser(email, password);
      return Right(token);
    } catch (e) {
      // Return failure if something goes wrong
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerUser(AuthEntity user) async {
    try {
      // Register a new user via the local data source
      await _authLocalDataSource.registerUser(user);
      return const Right(null);
    } catch (e) {
      // Return failure if something goes wrong
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, AuthEntity>> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, AuthEntity>> register(String username, String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
