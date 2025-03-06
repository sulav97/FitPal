import 'package:dartz/dartz.dart';
import 'package:gym_tracker_app/core/error/failure.dart';
import 'package:gym_tracker_app/features/Login/data/models/login_modal.dart';
import 'package:gym_tracker_app/features/Login/domain/entities/login_entity.dart';
import 'package:hive_flutter/hive_flutter.dart';

class UserHiveStorage {
  static const String _boxName = 'userBox';

  Future<Either<Failure, bool>> setUserData(UserEntity data) async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.put('user', data.toJson());
      return const Right(true);
    } catch (e) {
      return Left(HiveStorageFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, User>> getUserData() async {
    try {
      final box = await Hive.openBox(_boxName);
      final userData = box.get('user');

      if (userData == null) {
        return Left(HiveStorageFailure(message: 'No user data found'));
      }

      final user = User.fromJson(Map<String, dynamic>.from(userData));
      return Right(user);
    } catch (e) {
      return Left(HiveStorageFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, bool>> updateUserData(User updatedUser) async {
    try {
      final result = await getUserData();
      return result.fold(
        (failure) => Left(failure),
        (currentUser) async {
          final box = await Hive.openBox(_boxName);
          final updatedData = {...currentUser.toJson(), ...updatedUser.toJson()};
          await box.put('user', updatedData);
          return const Right(true);
        },
      );
    } catch (e) {
      return Left(HiveStorageFailure(message: e.toString()));
    }
  }

  Future<Either<Failure, bool>> clear() async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.delete('user');
      return const Right(true);
    } catch (e) {
      return Left(HiveStorageFailure(message: e.toString()));
    }
  }
}

class TokenHiveStorage {
  static const String _boxName = 'tokenBox';

  // Save Token
  Future<Either<Failure, bool>> saveToken(String token) async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.put('token', token);
      return const Right(true);
    } catch (e) {
      return Left(HiveStorageFailure(message: e.toString()));
    }
  }

  // Get Token
  Future<Either<Failure, String>> getToken() async {
    try {
      final box = await Hive.openBox(_boxName);
      final token = box.get('token');

      if (token != null) {
        return Right(token);
      } else {
        return Left(HiveStorageFailure(message: 'No token found'));
      }
    } catch (e) {
      return Left(HiveStorageFailure(message: e.toString()));
    }
  }

  // Clear Token
  Future<Either<Failure, bool>> clearToken() async {
    try {
      final box = await Hive.openBox(_boxName);
      await box.delete('token');
      return const Right(true);
    } catch (e) {
      return Left(HiveStorageFailure(message: e.toString()));
    }
  }
}

class HiveStorageFailure extends Failure {
  @override
  final String message;

  HiveStorageFailure({required this.message}) : super(message: '');

  @override
  String toString() => 'HiveStorageFailure: $message';
}
