import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:gym_tracker_app/app/di/di.dart';
import 'package:gym_tracker_app/features/Login/data/datasources/local_datasource/login_local_datasource.dart';
import 'package:gym_tracker_app/features/Login/domain/entities/login_entity.dart';
import 'package:gym_tracker_app/features/Login/domain/repositories/login_repository.dart';

// import 'package:wastemanagement/app/di/di.dart';
// import 'package:wastemanagement/features/auth/data/dto/login_dto.dart';

// import '../../../../app/shared_prefs/token_shared_prefs.dart';
// import '../../../../app/shared_prefs/user_shared_prefs.dart';
import '../../../../app/usecase/usecase.dart';
import '../../../../core/error/failure.dart';
// import '../repository/user_repository.dart';

class SignUpUserParams extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  final String firstName;
  final String lastName;
  final String nickName;

  const SignUpUserParams({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.firstName,
    required this.lastName,
    required this.nickName,
  });

  const SignUpUserParams.empty()
      : email = '_empty.email',
        password = '_empty.password',
        confirmPassword = '_empty.confirmPassword',
        firstName = '_empty.firstName',
        lastName = '_empty.lastName',
        nickName = '_empty.nickName';

  @override
  List<Object?> get props => [email, password, confirmPassword, firstName, lastName, nickName];
}

class SignUpUsecase implements UsecaseWithParams<LoginEntity, SignUpUserParams> {
  final IUserRepository userRepository;
  // final UserSharedPrefs tokenSharedPrefs;
  final UserHiveStorage userSharedPrefs;

  const SignUpUsecase({required this.userRepository, required this.userSharedPrefs});

  @override
  Future<Either<Failure, LoginEntity>> call(SignUpUserParams params) async {
    // Call the repository to sign up
    return userRepository
        .signUp(email: params.email, password: params.password, confirmPassword: params.confirmPassword, firstName: params.firstName, lastName: params.lastName, nickName: params.nickName)
        .then((value) {
      return value.fold((failure) => Left(failure), (userData) {
        // Save user data in Shared Preferences
        userSharedPrefs.setUserData(userData.user ?? const UserEntity());
        // tokenSharedPrefs.saveToken(userData.token);

        getIt<Dio>().options.headers['Authorization'] = userData.token;

        return Right(userData);
      });
    });
  }
}
