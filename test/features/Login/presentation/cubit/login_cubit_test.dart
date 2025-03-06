import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/features/Login/data/datasources/local_datasource/login_local_datasource.dart';
import 'package:gym_tracker_app/features/Login/domain/entities/login_entity.dart';
import 'package:gym_tracker_app/features/Login/domain/usecases/login_usecase.dart';
import 'package:gym_tracker_app/features/Login/presentation/cubit/login_cubit.dart';
import 'package:gym_tracker_app/features/Login/presentation/cubit/login_state.dart';
import 'package:gym_tracker_app/features/profile/domain/usecases/profile_usecase.dart';
import 'package:gym_tracker_app/features/signup/domain/usecases/sign_up_usecase.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes
class MockLoginUserUsecase extends Mock implements LoginUserUsecase {}

class MockSignUpUsecase extends Mock implements SignUpUsecase {}

class MockProfileUsecase extends Mock implements ProfileUsecase {}

class MockUserSharedPrefs extends Mock implements UserHiveStorage {}

class MockTokenSharedPrefs extends Mock implements TokenHiveStorage {}

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  late LoginCubit loginCubit;
  late MockLoginUserUsecase mockLoginUserUsecase;
  late MockSignUpUsecase mockSignUpUsecase;
  late MockProfileUsecase mockProfileUsecase;
  late MockUserSharedPrefs mockUserSharedPrefs;
  late MockTokenSharedPrefs mockTokenSharedPrefs;

  setUp(() {
    mockLoginUserUsecase = MockLoginUserUsecase();
    mockSignUpUsecase = MockSignUpUsecase();
    mockProfileUsecase = MockProfileUsecase();
    mockUserSharedPrefs = MockUserSharedPrefs();
    mockTokenSharedPrefs = MockTokenSharedPrefs();

    loginCubit = LoginCubit(
      loginUserUsecase: mockLoginUserUsecase,
      signUpUsecase: mockSignUpUsecase,
      profileUsecase: mockProfileUsecase,
      userSharedPrefs: mockUserSharedPrefs,
      tokenSharedPrefs: mockTokenSharedPrefs,
    );
  });

  tearDown(() {
    loginCubit.close();
  });

  group('LoginCubit', () {
    const email = 'test@example.com';
    const name = 'Test User';

    test('initial state is LoginState.initially()', () {
      expect(loginCubit.state, LoginState.initially());
    });

    group('setUser', () {
      test('should update user data in state', () {
        // Arrange
        const user = UserEntity(
          id: '1',
          name: name,
          email: email,
        );

        // Act
        loginCubit.setUser(user);

        // Assert
        expect(loginCubit.state.userData, user);
      });
    });
  });
}
