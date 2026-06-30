import 'package:equatable/equatable.dart';

import '../../data/models/my_users.dart';

class MyUsersEntity extends Equatable{
 final String id;
 final FirstName? firstName;
 final String lastName;
 final String email;
 final Gender gender;
 final String phone;
 final String photo;
 final DateTime passwordChangedAt;
 final bool resetCodeVerified;
 const MyUsersEntity({
   required this.id,
   required this.firstName,
   required this.lastName,
   required this.email,
   required this.gender,
   required this.phone,
   required this.photo,
   required this.passwordChangedAt,
   required this.resetCodeVerified,
});

  @override

  List<Object?> get props => [
    id,
    firstName,
    lastName,
    email,
    gender,
    phone,
    photo,
    passwordChangedAt,
    resetCodeVerified,
  ];
}