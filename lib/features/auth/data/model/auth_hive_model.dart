import 'package:college_community_mobileapp/app/constants/hive_table_constant.dart'; // Assuming this is where your constants are located
import 'package:college_community_mobileapp/features/auth/domain/entity/auth_entity.dart'; // AuthEntity
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs

part 'auth_hive_model.g.dart'; // Hive code generation part

@HiveType(typeId: HiveTableConstant.userTableId) // Ensure typeId matches your constant
class AuthHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;
  
  @HiveField(1)
  final String email;
  
  @HiveField(2)
  final String fname;
  
  @HiveField(3)
  final String lname;
  
  @HiveField(4)
  final String password;

  // Constructor to initialize the model
  AuthHiveModel({
    String? userId,
    required this.email,
    required this.fname,
    required this.lname,
    required this.password,
  }) : userId = userId ?? const Uuid().v4(); // Use UUID if userId is not provided

  // Initial Constructor with default values
  const AuthHiveModel.initial()
      : userId = '',
        email = '',
        fname = '',
        lname = '',
        password = '';

  // From Entity: Converts AuthEntity to AuthHiveModel
  factory AuthHiveModel.fromEntity(AuthEntity entity) {
    return AuthHiveModel(
      userId: entity.userId,
      email: entity.email,
      fname: entity.fname,
      lname: entity.lname,
      password: entity.password,
    );
  }

  // To Entity: Converts AuthHiveModel back to AuthEntity
  AuthEntity toEntity() {
    return AuthEntity(
      email: email,
      fname: fname,
      lname: lname,
      password: password,
    );
  }

  @override
  List<Object?> get props => [userId, email, fname, lname, password];
}
