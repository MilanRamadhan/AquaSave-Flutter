class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String token;
  final String iotId; // Pastikan properti ini ada
  final String password;
  final String? photoUrl;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.token,
    required this.iotId, // Tambahkan ini jika belum ada
    required this.password,
    this.photoUrl,
    this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? token,
    String? password,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      token: token ?? this.token,
      password: password ?? this.password,
      iotId: this.iotId, // Mengganti json dengan this.iotId
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
      password: json["password"] ?? '',
      iotId: json['iotId'] ?? '', // Ambil dari JSON response
      photoUrl: json["photoUrl"],
      createdAt:
          json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'token': token,
      'iotId': iotId, // Pastikan ini ada di JSON
      'password': password,
      'photoUrl': photoUrl,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.fullName == fullName &&
        other.email == email &&
        other.token == token &&
        other.photoUrl == photoUrl &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        fullName,
        email,
        token,
        photoUrl,
        createdAt,
      );
}
