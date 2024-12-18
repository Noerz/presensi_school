import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final String? idUser;
  final String? email;
  final String? nisn;
  final int? roleCode;
  final String? accessToken;
  final String? nama;
  final String? noHp;
  final String? alamat;
  final String? image;
  final String? kelas;
  // final int? userId;
  // final String? role;

  User({
    this.idUser,
    this.email,
    this.nisn,
    this.roleCode,
     this.accessToken,
    this.nama,
    this.noHp,
    this.alamat,
    this.image,
    this.kelas,
    // required this.userId,
    // required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        idUser: json["idUser"],
        email: json["email"],
        nisn: json["nisn"],
        roleCode: json["roleCode"],
        accessToken: json["accessToken"],
        nama: json["nama"],
        noHp: json["noHp"],
        alamat: json["alamat"],
        image: json["image"],
        kelas: json["kelas"],
        // userId: json["userId"],
        // role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "idUser": idUser,
        "email": email,
        "nisn": nisn,
        "roleCode": roleCode,
        "accessToken": accessToken,
        "nama": nama,
        "noHp": noHp,
        "alamat": alamat,
        "image": image,
        "kelas": kelas,
        // "userId": userId,
      };
}

List<User> usersFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
