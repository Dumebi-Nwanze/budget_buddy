import 'package:budget_buddy/models/budget_model.dart';
import 'package:budget_buddy/models/category_model.dart';
import 'package:budget_buddy/models/entry_model.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<NetworkResponse> addCategory(String userId, Category category) async {
    try {
      DocumentReference docRef = _firestore.collection('users').doc(userId);

      await docRef.update({
        'categories': FieldValue.arrayUnion([category.toJson()]),
      });

      return const NetworkResponse(
        status: Status.success,
        message: 'Category added successfully.',
      );
    } catch (e) {
      return NetworkResponse(
        status: Status.failed,
        message: e.toString(),
      );
    }
  }

  Future<NetworkResponse> addBudget({
    required Budget budget,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .doc(budget.id)
          .set(budget.toJson());
      return const NetworkResponse(
        status: Status.success,
        message: 'Budget added successfully',
      );
    } catch (e) {
      return NetworkResponse(
        status: Status.failed,
        message: e.toString(),
      );
    }
  }

  Future<NetworkResponse> addEntry({
    required Entry entry,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('entries')
          .doc(entry.id)
          .set(entry.toJson());
      return const NetworkResponse(
        status: Status.success,
        message: 'Entry added successfully',
      );
    } catch (e) {
      return NetworkResponse(
        status: Status.failed,
        message: e.toString(),
      );
    }
  }

  Future<NetworkResponse> getEntriesForDay({
    required String userId,
    required DateTime date,
  }) async {
    try {
      DateTime startOfDay = DateTime(date.year, date.month, date.day);
      DateTime endOfDay = startOfDay
          .add(const Duration(days: 1))
          .subtract(const Duration(seconds: 1));

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('entries')
          .where('createdAt',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .get();
      List<Entry> entries = snapshot.docs
          .map((doc) => Entry.fromSnapshot(doc))
          .where((t) => t.type == 'Expense')
          .toList();

      return NetworkResponse(
        status: Status.success,
        message: 'Entries retrieved successfully',
        data: entries,
      );
    } catch (e) {
      return NetworkResponse(
        status: Status.failed,
        message: e.toString(),
      );
    }
  }

  Future<NetworkResponse> getMonthBalance({
    required String userId,
    required DateTime date,
  }) async {
    try {
      // Calculate start and end of the month
      DateTime startOfMonth = DateTime(date.year, date.month, 1);
      DateTime endOfMonth =
          startOfMonth.add(Duration(days: 30)).subtract(Duration(seconds: 1));

      // Fetch entries within the specified month
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('entries')
          .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
          .where('createdAt', isLessThanOrEqualTo: endOfMonth)
          .get();

      // Process the snapshot to separate expenses and income
      List<Entry> expenses = [];
      List<Entry> income = [];

      snapshot.docs.forEach((doc) {
        Entry entry = Entry.fromSnapshot(doc);
        if (entry.type == 'Expense') {
          expenses.add(entry);
        } else if (entry.type == 'Income') {
          income.add(entry);
        }
      });

      return NetworkResponse(
        status: Status.success,
        message: 'Entries retrieved successfully',
        data: {"expense": expenses, "income": income},
      );
    } catch (e) {
      return NetworkResponse(
        status: Status.failed,
        message: e.toString(),
      );
    }
  }

  Future<NetworkResponse> getBudgets({
    required String userId,
    required DateTime date,
  }) async {
    logger.d(date);
    try {
      // Calculate start and end of the month
      DateTime startOfMonth = DateTime(date.year, date.month, 1);
      DateTime endOfMonth =
          startOfMonth.add(Duration(days: 30)).subtract(Duration(seconds: 1));

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('budgets')
          .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
          .where('createdAt', isLessThanOrEqualTo: endOfMonth)
          .get();

      List<Budget> budgets =
          snapshot.docs.map((doc) => Budget.fromSnapshot(doc)).toList();
      logger.d(budgets);

      return NetworkResponse(
        status: Status.success,
        message: 'Budgets retrieved successfully',
        data: budgets,
      );
    } catch (e) {
      logger.e(e);
      return NetworkResponse(
        status: Status.failed,
        message: e.toString(),
      );
    }
  }

  Future<NetworkResponse> getMonthlyExpenses({
    required String userId,
    required DateTime date,
  }) async {
    try {
      // Calculate start and end of the month
      DateTime startOfMonth = DateTime(date.year, date.month, 1);
      DateTime endOfMonth =
          startOfMonth.add(Duration(days: 30)).subtract(Duration(seconds: 1));

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('entries')
          .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
          .where('createdAt', isLessThanOrEqualTo: endOfMonth)
          .get();

      List<Entry> expenses = [];

      snapshot.docs.forEach((doc) {
        Entry entry = Entry.fromSnapshot(doc);
        if (entry.type == 'Expense') {
          expenses.add(entry);
        }
      });

      return NetworkResponse(
        status: Status.success,
        message: 'Expenses retrieved successfully',
        data: expenses,
      );
    } catch (e) {
      return NetworkResponse(
        status: Status.failed,
        message: e.toString(),
      );
    }
  }

  Future<NetworkResponse> getAllTimeIncomeExpense({
    required String userId,
  }) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('entries')
          .get();

      List<Entry> expenses = [];
      List<Entry> income = [];

      snapshot.docs.forEach((doc) {
        Entry entry = Entry.fromSnapshot(doc);
        if (entry.type == 'Expense') {
          expenses.add(entry);
        } else if (entry.type == 'Income') {
          income.add(entry);
        }
      });

      return NetworkResponse(
        status: Status.success,
        message: 'Entries retrieved successfully',
        data: {"expense": expenses, "income": income},
      );
    } catch (e) {
      return NetworkResponse(
        status: Status.failed,
        message: e.toString(),
      );
    }
  }

  Future<NetworkResponse> getNetBalancePerMonth({
    required DateTime month,
    required String userId,
  }) async {
    try {
      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('entries')
          .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
          .where('createdAt', isLessThanOrEqualTo: endOfMonth)
          .get();

      Map<DateTime, double> netBalanceChanges = {};

      for (var doc in snapshot.docs) {
        Entry entry = Entry.fromSnapshot(doc);
        double change = entry.type == 'Income' ? entry.amount : -entry.amount;

        DateTime date = DateTime(
            entry.createdAt.year, entry.createdAt.month, entry.createdAt.day);

        if (netBalanceChanges.containsKey(date)) {
          netBalanceChanges[date] = netBalanceChanges[date]! + change;
        } else {
          netBalanceChanges[date] = change;
        }
      }

      return NetworkResponse(
        status: Status.success,
        message: 'Net balance changes retrieved successfully',
        data: netBalanceChanges,
      );
    } catch (e) {
      return NetworkResponse(
        status: Status.failed,
        message: e.toString(),
      );
    }
  }
}
