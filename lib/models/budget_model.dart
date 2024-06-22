import 'package:budget_buddy/models/category_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Budget {
  final String id;
  final String name;
  final String description;
  final double amount;
  final Category category;
  final DateTime createdAt;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? updatedAt;

  Budget({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.category,
    required this.createdAt,
    required this.startDate,
    required this.endDate,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
      'category': category.toJson(),
      'createdAt': createdAt,
      'startDate': startDate,
      'endDate': endDate,
      'updatedAt': updatedAt,
    };
  }

  static Budget fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      category: Category.fromJson(json['category']),
      createdAt: json['createdAt'].toDate(),
      startDate: json['startDate'].toDate(),
      endDate: json['endDate'].toDate(),
      updatedAt: json['updatedAt']?.toDate(),
    );
  }

  static Budget fromSnapshot(QueryDocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Budget(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      amount: data['amount'].toDouble(),
      category: Category.fromJson(data['category']),
      createdAt: data['createdAt'].toDate(),
      startDate: data['startDate'].toDate(),
      endDate: data['endDate'].toDate(),
      updatedAt: data['updatedAt']?.toDate(),
    );
  }
}
