class ProfileUserBackend {
    final int id;
    final String email;
    final String firstName;
    final String lastName;
    final String photoUrl;
    final String role;

    ProfileUserBackend({
        required this.id,
        required this.email,
        required this.firstName,
        required this.lastName,
        required this.photoUrl,
        required this.role,
    });

    factory ProfileUserBackend.fromJson(Map<String, dynamic> json) => ProfileUserBackend(
        id: json["id"],
        email: json["email"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        photoUrl: json["photoUrl"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "photoUrl": photoUrl,
        "role": role,
    };
}
