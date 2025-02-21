class UserModel {
   final String uid;
   final String? name;
   final String? phoneNumber;
   final int? age;
   final String? email;
   final String? password;
   final List<double>? ratings ;


   UserModel({
      required this.uid,
      this.name,
      this.phoneNumber,
      this.age,
      this.email,
      this.password,
      this.ratings,
   });

   factory UserModel.fromMap(Map<String, dynamic> map, [String? id]) {
      return UserModel(
         uid: id ?? map['uid'] as String,
         name: map['name'] as String?,
         phoneNumber: map['phoneNumber'] as String?,
         age: map['age'] as int?,
         email: map['email'] as String?,
         password: map['password'] as String?,
         ratings: map['ratings'] != null
             ? List<double>.from(map['ratings'].map((e) => e is int ? (e as int).toDouble() : e as double))
             : null,  // Safely handle list of ratings as double
      );
   }

   factory UserModel.unknown() {
      return UserModel(
         uid: 'unknown',
         name: 'Unknown Worker',
      );
   }

   Map<String, dynamic> toMap() {
      return {
         'uid': uid,
         'name': name,
         'phoneNumber': phoneNumber,
         'age': age,
         'email': email,
         'password': password,
      };
   }
}