import 'package:equatable/equatable.dart';

class BusLine extends Equatable{
  final int id;
  final String code;
  final String name;
  final String imagePath;

  const BusLine({
    required this.id,
    required this.code,
    required this.name,
    required this.imagePath,
  });
  
  @override
  List<Object?> get props => [id, code, name, imagePath];
}