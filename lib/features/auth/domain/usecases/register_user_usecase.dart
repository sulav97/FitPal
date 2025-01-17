import 'package:college_community_mobileapp/core/error/failure.dart';
import 'package:college_community_mobileapp/features/auth/domain/entity/auth_entity.dart';
import 'package:college_community_mobileapp/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, AuthEntity>> execute(
    String username,
    String email,
    String password,
  ) async {
    return await repository.register(username, email, password);
  }
}
