import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/core/error/failure.dart';
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
    const password = 'password123';
    const name = 'Test User';
    const token = 'fake-token';

    const loginEntity = LoginEntity(
      token: token,
      user: UserEntity(
        id: '1',
        name: name,
        email: email,
      ),
    );

    test('initial state is LoginState.initially()', () {
      expect(loginCubit.state, LoginState.initially());
    });

    group('loginFx', () {
      test('should emit loading and success states on successful login', () async {
        // Arrange
        when(() => mockLoginUserUsecase.call(any())).thenAnswer((_) async => const Right(loginEntity));
        when(() => mockUserSharedPrefs.setUserData(any())).thenAnswer((_) async => Left(ApiFailure(message: '')));
        when(() => mockTokenSharedPrefs.saveToken(any())).thenAnswer((_) async => Left(ApiFailure(message: '')));

        // Act
        loginCubit.loginFx(
          MockBuildContext(),
          email: email,
          password: password,
        );

        // Assert
        await expectLater(
          loginCubit.stream,
          emitsInOrder([
            LoginState.initially().copyWith(isLoadingState: true),
            LoginState.initially().copyWith(isLoadingState: false, userData: loginEntity.user),
          ]),
        );

        verify(() => mockLoginUserUsecase.call(const LoginUserParams(email: email, password: password))).called(1);
        verify(() => mockUserSharedPrefs.setUserData(loginEntity.user!)).called(1);
        verify(() => mockTokenSharedPrefs.saveToken(loginEntity.token!)).called(1);
      });

      test('should emit loading and error states on login failure', () async {
        // Arrange
        var failure = ApiFailure(message: 'Login failed');
        when(() => mockLoginUserUsecase.call(any())).thenAnswer((_) async => Left(failure));

        // Act
        loginCubit.loginFx(
          MockBuildContext(),
          email: email,
          password: password,
        );

        // Assert
        await expectLater(
          loginCubit.stream,
          emitsInOrder([
            LoginState.initially().copyWith(isLoadingState: true),
            LoginState.initially().copyWith(isLoadingState: false),
          ]),
        );

        verify(() => mockLoginUserUsecase.call(const LoginUserParams(email: email, password: password))).called(1);
        verifyNever(() => mockUserSharedPrefs.setUserData(any()));
        verifyNever(() => mockTokenSharedPrefs.saveToken(any()));
      });
    });

    group('signUpFx', () {
      test('should emit loading and success states on successful signup', () async {
        // Arrange
        when(() => mockSignUpUsecase.call(any())).thenAnswer((_) async => const Right(loginEntity));
        when(() => mockUserSharedPrefs.setUserData(any())).thenAnswer((_) async => Left(ApiFailure(message: '')));
        when(() => mockTokenSharedPrefs.saveToken(any())).thenAnswer((_) async => Left(ApiFailure(message: '')));

        // Act
        loginCubit.signUpFx(
          MockBuildContext(),
          email: email,
          password: password,
          confirmPassword: password,
          firstName: 'Test',
          lastName: 'User',
          nickName: 'User',
        );

        // Assert
        await expectLater(
          loginCubit.stream,
          emitsInOrder([
            LoginState.initially().copyWith(isLoadingState: true),
            LoginState.initially().copyWith(isLoadingState: false, userData: loginEntity.user),
          ]),
        );

        verify(() => mockSignUpUsecase.call(const SignUpUserParams(
              email: email,
              password: password,
              firstName: 'Test',
              lastName: 'User',
              confirmPassword: 'User',
              nickName: 'User',
            ))).called(1);
      });

      test('should emit loading and error states on signup failure', () async {
        // Arrange
        var failure = ApiFailure(message: 'Signup failed');
        when(() => mockSignUpUsecase.call(any())).thenAnswer((_) async => Left(failure));

        // Act
        loginCubit.signUpFx(
          MockBuildContext(),
          email: email,
          password: password,
          confirmPassword: password,
          firstName: 'Test',
          lastName: 'User',
          nickName: 'User',
        );

        // Assert
        await expectLater(
          loginCubit.stream,
          emitsInOrder([
            LoginState.initially().copyWith(isLoadingState: true),
            LoginState.initially().copyWith(isLoadingState: false),
          ]),
        );

        verify(() => mockSignUpUsecase.call(const SignUpUserParams(email: email, password: password, firstName: 'Test', lastName: 'User', confirmPassword: 'Con', nickName: 'nik'))).called(1);
      });
    });

    group('logOut', () {
      test('should clear user data and token on logout', () async {
        // Arrange
        when(() => mockTokenSharedPrefs.clearToken()).thenAnswer((_) async => Left(ApiFailure(message: '')));
        when(() => mockUserSharedPrefs.clear()).thenAnswer((_) async => Left(ApiFailure(message: '')));

        // Act
        loginCubit.logOut(MockBuildContext());

        // Assert
        await expectLater(
          loginCubit.stream,
          emitsInOrder([
            LoginState.initially().copyWith(token: null, userData: null),
          ]),
        );

        verify(() => mockTokenSharedPrefs.clearToken()).called(1);
        verify(() => mockUserSharedPrefs.clear()).called(1);
      });
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
