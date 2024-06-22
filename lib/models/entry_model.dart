import 'dart:convert';

import 'package:budget_buddy/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Entry {
  final String id;
  final String type;
  final String name;
  final String description;
  final Category category;
  final double amount;
  final DateTime createdAt;

  Entry({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.category,
    required this.amount,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'description': description,
      'category': category.toJson(),
      'amount': amount,
      'createdAt': createdAt,
    };
  }

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      description: json['description'],
      category: Category.fromJson(json['category']),
      amount: json['amount'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  static Entry fromSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Entry(
      id: data['id'],
      type: data['type'],
      name: data['name'],
      description: data['description'],
      category: Category.fromJson(data['category']),
      amount: data['amount'].toDouble(),
      createdAt: data['createdAt'].toDate(),
    );
  }
}
