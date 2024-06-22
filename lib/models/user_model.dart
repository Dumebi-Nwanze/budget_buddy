import 'dart:convert';

import 'package:budget_buddy/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String displayName;

  final double income;
  final double expenses;
  final List<Category> categories;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.createdAt,
    required this.income,
    required this.expenses,
    required this.categories,
  });

  // Convert a UserModel object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'createdAt': createdAt.toIso8601String(),
      'income': income,
      'expenses': expenses,
      'categories':
          categories.map((category) => category.toJson()).toList() ?? [],
    };
  }

  // Create a UserModel object from a Firestore snapshot
  static UserModel fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      uid: data["uid"],
      email: data['email'],
      displayName: data['displayName'],
      createdAt: DateTime.tryParse(data['createdAt'])!,
      income: data['income'].toDouble(),
      expenses: data['expenses'].toDouble(),
      categories: (data['categories'] as List)
          .map((cat) => Category.fromJson(cat as Map<String, dynamic>))
          .toList(),
    );
  }

  static UserModel fromJson(String jsonString) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return UserModel(
      uid: jsonMap['uid'],
      displayName: jsonMap['displayName'],
      email: jsonMap['email'],
      income: jsonMap['income'],
      expenses: jsonMap['expenses'],
      createdAt: DateTime.parse(jsonMap['createdAt']),
      categories: (jsonMap['categories'] as List)
          .map((cat) => Category.fromJson(cat as Map<String, dynamic>))
          .toList(),
    );
  }
}
