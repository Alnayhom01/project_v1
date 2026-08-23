class ReportModel {
  final String? id;
  final String? type;
  final String? notes;
  final double? latitude;
  final double? longitude;
  final List<String> images;

  const ReportModel({this.id, this.type, this.notes, this.latitude, this.longitude, this.images = const []});

  Map<String, dynamic> toMap() => {
    'id': id, 'type': type, 'notes': notes, 'latitude': latitude, 'longitude': longitude, 'images': images,
  };
}
