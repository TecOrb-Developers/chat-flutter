class UserModel {
  String? uid;
  String? name;
  String? email;
  String? photoUrl;

  UserModel({
    this.uid = "",
    this.name,
    this.email,
    this.photoUrl,
  });

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "name": name,
        "email": email,
        "photoUrl": photoUrl,
      };

  static UserModel fromMap(Map<String, dynamic> map) => UserModel(
        uid: map["uid"],
        name: map["name"],
        email: map["email"],
        photoUrl: map["photoUrl"],
      );
}
