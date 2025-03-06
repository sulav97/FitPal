import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gym_tracker_app/core/error/failure.dart';
import 'package:gym_tracker_app/features/Login/data/datasources/local_datasource/login_local_datasource.dart';
import 'package:gym_tracker_app/features/Login/domain/entities/login_entity.dart';
import 'package:gym_tracker_app/features/Login/domain/repositories/login_repository.dart';
import 'package:gym_tracker_app/features/signup/domain/usecases/sign_up_usecase.dart';
import 'package:mocktail/mocktail.dart';

// Mock the IUserRepository
class MockUserRepository extends Mock implements IUserRepository {}

// Mock the UserHiveStorage
class MockUserHiveStorage extends Mock implements UserHiveStorage {}

void main() {
  late SignUpUsecase signUpUsecase;
  late MockUserRepository mockUserRepository;
  late MockUserHiveStorage mockUserHiveStorage;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockUserHiveStorage = MockUserHiveStorage();
    signUpUsecase = SignUpUsecase(
      userRepository: mockUserRepository,
      userSharedPrefs: mockUserHiveStorage,
    );
  });

  SignUpUserParams params = const SignUpUserParams(
    email: 'test@example.com',
    password: 'password123',
    confirmPassword: 'password123',
    firstName: 'John',
    lastName: 'Doe',
    nickName: 'Johnny',
  );

  LoginEntity loginEntity = const LoginEntity(
    user: UserEntity(
      id: '1',
      email: 'test@example.com',
    ),
    token: 'token123',
  );

  // test('should sign up user and return LoginEntity when successful', () async {
  //   // Arrange
  //   when(() => mockUserRepository.signUp(
  //         email: any(named: 'email'),
  //         password: any(named: 'password'),
  //         confirmPassword: any(named: 'confirmPassword'),
  //         firstName: any(named: 'firstName'),
  //         lastName: any(named: 'lastName'),
  //         nickName: any(named: 'nickName'),
  //       )).thenAnswer((_) async => Right(loginEntity));

  //   // Mock the setUserData method to return a successful response
  //   when(() => mockUserHiveStorage.setUserData(loginEntity.user!)).thenAnswer((_) async => const Right(true));

  //   // Act
  //   final result = await signUpUsecase(params);

  //   // Assert
  //   expect(result, Right(loginEntity));
  //   verify(() => mockUserRepository.signUp(
  //         email: params.email,
  //         password: params.password,
  //         confirmPassword: params.confirmPassword,
  //         firstName: params.firstName,
  //         lastName: params.lastName,
  //         nickName: params.nickName,
  //       ));
  //   verify(() => mockUserHiveStorage.setUserData(loginEntity.user!));
  //   verifyNoMoreInteractions(mockUserRepository);
  //   verifyNoMoreInteractions(mockUserHiveStorage);
  // });

  test('should return Failure when sign up fails', () async {
    // Arrange
    var failure = ApiFailure(message: 'Sign up failed');
    when(() => mockUserRepository.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          confirmPassword: any(named: 'confirmPassword'),
          firstName: any(named: 'firstName'),
          lastName: any(named: 'lastName'),
          nickName: any(named: 'nickName'),
        )).thenAnswer((_) async => Left(failure));

    // Act
    final result = await signUpUsecase(params);

    // Assert
    expect(result, Left(failure));
    verify(() => mockUserRepository.signUp(
          email: params.email,
          password: params.password,
          confirmPassword: params.confirmPassword,
          firstName: params.firstName,
          lastName: params.lastName,
          nickName: params.nickName,
        ));
    verifyZeroInteractions(mockUserHiveStorage);
    verifyNoMoreInteractions(mockUserRepository);
  });
}
