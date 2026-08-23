class ReportModel {
  final String id;
  final String type;
  final String notes;
  final double latitude;
  final double longitude;
  final List<String> images;
  final DateTime createdAt;
  final DateTime expiresAt;

  const ReportModel({required this.id, required this.type, required this.notes, required this.latitude, required this.longitude, required this.images, required this.createdAt, required this.expiresAt});

  Map<String, dynamic> toMap() => {
    'id': id, 'type': type, 'notes': notes, 'latitude': latitude, 'longitude': longitude,
    'images': images, 'createdAt': createdAt.toIso8601String(), 'expiresAt': expiresAt.toIso8601String(),
  };

  factory ReportModel.fromMap(Map<String, dynamic> m) => ReportModel(
    id: m['id'].toString(), type: m['type']?.toString() ?? '', notes: m['notes']?.toString() ?? '',
    latitude: (m['latitude'] as num).toDouble(), longitude: (m['longitude'] as num).toDouble(),
    images: List<String>.from(m['images'] ?? const []),
    createdAt: DateTime.parse(m['createdAt'].toString()), expiresAt: DateTime.parse(m['expiresAt'].toString()),
  );
}
