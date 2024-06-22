import 'package:budget_buddy/models/budget_model.dart';
import 'package:budget_buddy/models/entry_model.dart';
import 'package:budget_buddy/repository/transaction_repository.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TransactionsProvider extends ChangeNotifier {
  Status addingBudget = Status.initial;
  Status addingEntry = Status.initial;
  Status gettingMonthly = Status.initial;
  Status gettingEntries = Status.initial;
  Status gettingBudgets = Status.initial;
  Status gettingExpenses = Status.initial;
  Status gettingAllTime = Status.initial;
  Status gettingChartData = Status.initial;
  List<Entry> _dailyEntries = [];
  List<Entry> _monthlyExpenses = [];
  List<Entry> _monthlyIncome = [];
  List<Entry> _allTimeExpenses = [];
  List<Entry> _allTimeIncome = [];
  List<Entry> _monthlyBudgetExpenses = [];
  List<Budget> _monthlyBudget = [];
  List<FlSpot> spots = [];

  List<Entry> get dailyEntries => _dailyEntries;
  List<Entry> get monthlyExpenses => _monthlyExpenses;
  List<Entry> get monthlyIncome => _monthlyIncome;
  List<Entry> get allTimeExpenses => _allTimeExpenses;
  List<Entry> get allTimeIncome => _allTimeIncome;
  List<Entry> get monthlyBudgetExpenses => _monthlyBudgetExpenses;
  List<Budget> get monthlyBudget => _monthlyBudget;
  String message = "";
  final _transactionRepo = TransactionRepository();

  Future<void> addBudget({
    required Budget budget,
    required String userId,
  }) async {
    if (addingBudget == Status.loading) {
      return;
    }
    addingBudget = Status.loading;
    notifyListeners();
    final res =
        await _transactionRepo.addBudget(budget: budget, userId: userId);
    if (res.status == Status.success) {
      message = res.message;
      addingBudget = res.status;
      notifyListeners();
    } else {
      message = res.message;
      addingBudget = res.status;
      notifyListeners();
    }
  }

  Future<void> addEntry({
    required Entry entry,
    required String userId,
  }) async {
    if (addingEntry == Status.loading) {
      return;
    }
    addingEntry = Status.loading;
    notifyListeners();
    final res = await _transactionRepo.addEntry(entry: entry, userId: userId);

    if (res.status == Status.success) {
      message = res.message;
      addingEntry = res.status;
      notifyListeners();
    } else {
      message = res.message;
      addingEntry = res.status;
      notifyListeners();
    }
  }

  Future<void> getEntries({
    required String userId,
    required DateTime date,
  }) async {
    if (gettingEntries == Status.loading) {
      return;
    }
    gettingEntries = Status.loading;
    notifyListeners();
    final res =
        await _transactionRepo.getEntriesForDay(userId: userId, date: date);
    if (res.status == Status.success) {
      message = res.message;
      gettingEntries = res.status;
      _dailyEntries = res.data;
      notifyListeners();
    } else {
      message = res.message;
      gettingEntries = res.status;
      notifyListeners();
    }
  }

  Future<void> getMonthly({
    required String userId,
    required DateTime date,
  }) async {
    if (gettingMonthly == Status.loading) {
      return;
    }
    gettingMonthly = Status.loading;
    notifyListeners();
    final res =
        await _transactionRepo.getMonthBalance(userId: userId, date: date);
    if (res.status == Status.success) {
      message = res.message;
      gettingMonthly = res.status;
      _monthlyExpenses = res.data["expense"];
      _monthlyIncome = res.data["income"];
      notifyListeners();
    } else {
      message = res.message;
      gettingMonthly = res.status;
      notifyListeners();
    }
  }

  Future<void> getBudgets({
    required String userId,
    required DateTime date,
  }) async {
    if (gettingBudgets == Status.loading) {
      return;
    }
    gettingBudgets = Status.loading;
    notifyListeners();
    final res = await _transactionRepo.getBudgets(userId: userId, date: date);
    if (res.status == Status.success) {
      message = res.message;
      gettingBudgets = res.status;
      _monthlyBudget = res.data;
      notifyListeners();
    } else {
      message = res.message;
      gettingBudgets = res.status;
      notifyListeners();
    }
  }

  Future<void> getMonthlyExpenses({
    required String userId,
    required DateTime date,
  }) async {
    if (gettingExpenses == Status.loading) {
      return;
    }
    gettingExpenses = Status.loading;
    notifyListeners();
    final res =
        await _transactionRepo.getMonthlyExpenses(userId: userId, date: date);
    if (res.status == Status.success) {
      message = res.message;
      gettingExpenses = res.status;
      _monthlyBudgetExpenses = res.data;
      notifyListeners();
    } else {
      message = res.message;
      gettingExpenses = res.status;
      notifyListeners();
    }
  }

  Future<void> getAllTime({
    required String userId,
  }) async {
    if (gettingAllTime == Status.loading) {
      return;
    }
    gettingAllTime = Status.loading;
    notifyListeners();
    final res = await _transactionRepo.getAllTimeIncomeExpense(userId: userId);
    if (res.status == Status.success) {
      message = res.message;
      gettingAllTime = res.status;
      _allTimeExpenses = res.data["expense"];
      _allTimeIncome = res.data["income"];

      notifyListeners();
    } else {
      message = res.message;
      gettingAllTime = res.status;
      notifyListeners();
    }
  }

  Future<void> getChartData({
    required String userId,
    required DateTime date,
  }) async {
    if (gettingChartData == Status.loading) {
      return;
    }
    gettingChartData = Status.loading;
    notifyListeners();
    final res = await _transactionRepo.getNetBalancePerMonth(
        userId: userId, month: date);
    if (res.status == Status.success) {
      message = res.message;
      gettingChartData = res.status;
      final netBalanceChanges = res.data;
      if (netBalanceChanges != null || netBalanceChanges.isNotEmpty) {
        List<DateTime> sortedDates = netBalanceChanges.keys.toList()..sort();

        double runningBalance = 0.0;
        spots.clear();
        spots.add(FlSpot(1, runningBalance));
        for (var date in sortedDates) {
          runningBalance += netBalanceChanges[date]!;
          spots.add(FlSpot(date.day.toDouble(), runningBalance));
        }
      }

      notifyListeners();
    } else {
      message = res.message;
      gettingChartData = res.status;
      notifyListeners();
    }
  }
}
