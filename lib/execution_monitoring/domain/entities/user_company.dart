class UserCompany {
  final int id;
  final String gmail;
  final String role;

  UserCompany({required this.id, required this.gmail, required this.role});

  factory UserCompany.fromJson(Map<String, dynamic> json) => UserCompany(
        id: json["id"],
        gmail: json["gmail"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "gmail": gmail,
        "role": role,
    };
}
