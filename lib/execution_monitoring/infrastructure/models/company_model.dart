import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/company.dart';
import 'package:chapa_tu_bus_app/execution_monitoring/domain/entities/user_company.dart';

class CompanyModel {
    final int id;
    final String name;
    final String busImageUrl;
    final String logoImageUrl;
    final String description;
    final UserCompany user;
    final bool isDeleted;

    CompanyModel({
        required this.id,
        required this.name,
        required this.busImageUrl,
        required this.logoImageUrl,
        required this.description,
        required this.user,
        required this.isDeleted,
    });

    factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
        id: json["id"],
        name: json["name"],
        busImageUrl: json["busImageUrl"],
        logoImageUrl: json["logoImageUrl"],
        description: json["description"],
        user: UserCompany.fromJson(json["user"]),
        isDeleted: json["isDeleted"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "busImageUrl": busImageUrl,
        "logoImageUrl": logoImageUrl,
        "description": description,
        "user": user.toJson(),
        "isDeleted": isDeleted,
    };

    Company toEntity() {
    return Company(
      id: id,
      name: name,
      busImageUrl: busImageUrl,
      logoImageUrl: logoImageUrl,
      description: description,
      user: user, 
      isDeleted: isDeleted,
    );
  }
}

