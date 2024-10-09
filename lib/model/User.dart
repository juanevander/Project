class User {
  String id;
  String companyCode;
  String nik;
  String name;
  String email;
  String role;
  String emailVerifiedAt;
  String createdAt;
  String updatedAt;
  String position;
  String division;
  String deletionIndicator;

  User({
    required this.id,
    required this.companyCode,
    required this.nik,
    required this.name,
    required this.email,
    required this.role,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.position,
    required this.division,
    required this.deletionIndicator,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      companyCode: json['company_code'],
      nik: json['nik'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      position: json['position'],
      division: json['division'],
      deletionIndicator: json['deletion_indicator'],
    );
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      // 'access_token': access_token,
    };
  }
}
