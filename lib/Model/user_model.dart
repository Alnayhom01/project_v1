class UserModel {
  final String? id;
  final String name;
  final String phone;

  const UserModel({this.id, required this.name, required this.phone});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'phone': phone};
}
