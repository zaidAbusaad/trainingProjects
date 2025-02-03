class UserModel {
   final String uid;

   String? name;
   String? phoneNumber;
   int? age;
   String? email;
   String? password;

   UserModel({  this.name,  this.age,  this.phoneNumber, this.email, this.password,required this.uid });
}