import 'package:college_community_mobileapp/core/error/failure.dart';
import 'package:college_community_mobileapp/features/auth/domain/entity/auth_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login(String email, String password);
  Future<Either<Failure, AuthEntity>> register(
    String username,
    String email,
    String password,
  );
}
