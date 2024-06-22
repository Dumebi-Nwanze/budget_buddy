import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String icon;
  final String name;

  Category({
    required this.id,
    required this.icon,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'name': name,
    };
  }

  static Category fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Category(
      id: snapshot['id'],
      icon: snapshot['icon'],
      name: data['name'],
    );
  }

  static Category fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      icon: json['icon'],
      name: json['name'],
    );
  }
}
