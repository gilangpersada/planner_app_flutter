import 'package:party_planner/core/models/user.dart';

class Shared {
  final String id;
  final String title;
  final List<User> members;
  final int color;
  final String admin;
  final String code;

  Shared({
    this.id,
    this.title,
    this.members,
    this.color,
    this.admin,
    this.code,
  });

  factory Shared.fromMap(Map data, String id, List<User> members) {
    return Shared(
      id: id ?? '',
      title: data['shared_name'] ?? '',
      members: members ?? [],
      color: data['color'] ?? null,
      admin: data['admin'] ?? '',
      code: data['code'] ?? '',
    );
  }
}
