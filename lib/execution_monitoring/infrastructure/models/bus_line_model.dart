class BusLineModel {
  int busLineId;
  String busLineCode;
  String busLineName;
  String imagePath;

  BusLineModel({
    required this.busLineId,
    required this.busLineCode,
    required this.busLineName,
    required this.imagePath,
  });

  // Optional: Constructors to create from Map (useful for JSON)
  BusLineModel.fromJson(Map<String, dynamic> json)
      : busLineId = json['busLineId'],
        busLineCode = json['busLineCode'],
        busLineName = json['busLineName'],
        imagePath = json['imagePath'];

  // Optional: Method to convert to Map (useful for JSON)
  Map<String, dynamic> toJson() => {
    'busLineId': busLineId,
    'busLineCode': busLineCode,
    'busLineName': busLineName,
    'imagePath': imagePath,
  };
}