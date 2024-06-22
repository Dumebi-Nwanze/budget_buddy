import 'package:budget_buddy/json/budget_json.dart';
import 'package:budget_buddy/models/entry_model.dart';
import 'package:budget_buddy/providers/auth_provider.dart';
import 'package:budget_buddy/providers/transactions_provider.dart';
import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BudgetPage extends StatefulWidget {
  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  int activeMonth = 0;
  List<Map<String, dynamic>> months = [];

  void generateMonths() {
    DateTime today = DateTime.now();
    for (int i = 11; i >= 0; i--) {
      DateTime monthDate = DateTime(today.year, today.month - i, 1);
      months.add({
        'label': DateFormat('y').format(monthDate),
        'day': DateFormat('MMM').format(monthDate),
        'date': monthDate,
      });
    }
    setState(() {
      activeMonth = months.length - 1;
    });
  }

  @override
  void initState() {
    super.initState();
    generateMonths();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transProvider = context.read<TransactionsProvider>();
      final authProvider = context.read<AuthProvider>();

      transProvider.getBudgets(
          userId: authProvider.user!.uid, date: DateTime.now());
      transProvider.getMonthlyExpenses(
          userId: authProvider.user!.uid, date: DateTime.now());
    });
  }

  final formatter = NumberFormat.compactCurrency(
    decimalDigits: 2,
    symbol: '₦',
  );

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactionsProvider, AuthProvider>(
        builder: (context, transactionProvider, authProvider, child) {
      Set<String> budgetCategories = {};
      for (var budget in transactionProvider.monthlyBudget) {
        budgetCategories.add(budget.category.id);
      }

      List<Map<String, dynamic>> budgets = [];
      List<Entry> expenses = [];
      for (var expense in transactionProvider.monthlyBudgetExpenses) {
        if (budgetCategories.contains(expense.category.id)) {
          expenses.add(expense);
        }
      }
      for (var budget in transactionProvider.monthlyBudget) {
        double totalSpent = expenses
            .where((expense) => expense.category.id == budget.category.id)
            .fold(0, (sum, expense) => sum + expense.amount);

        double percentageSpent = totalSpent / budget.amount;

        budgets.add({
          "name": budget.name,
          "amount": formatter.format(totalSpent),
          "total": formatter.format(budget.amount),
          "label_percentage": "${(percentageSpent * 100).toStringAsFixed(0)}%",
          "percentage": percentageSpent,
        });
      }
      return Scaffold(
        backgroundColor: grey.withOpacity(0.05),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: white, boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.01),
                  spreadRadius: 10,
                  blurRadius: 3,
                  // changes position of shadow
                ),
              ]),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 60, right: 20, left: 20, bottom: 25),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Budgets",
                          style: boldTextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(months.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  activeMonth = index;
                                });
                                transactionProvider.getBudgets(
                                    userId: authProvider.user!.uid,
                                    date: months[index]['date']);
                                transactionProvider.getMonthlyExpenses(
                                    userId: authProvider.user!.uid,
                                    date: months[index]['date']);
                              },
                              child: SizedBox(
                                width:
                                    (MediaQuery.of(context).size.width - 40) /
                                        6,
                                child: Column(
                                  children: [
                                    Text(
                                      months[index]['label'],
                                      style: secondaryTextStyle(fontSize: 10),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: activeMonth == index
                                              ? secondaryColor
                                              : black.withOpacity(0.02),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: activeMonth == index
                                                  ? secondaryColor
                                                  : black.withOpacity(0.1))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12,
                                            right: 12,
                                            top: 7,
                                            bottom: 7),
                                        child: Text(
                                          months[index]['day'],
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: activeMonth == index
                                                  ? white
                                                  : black),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          })),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            transactionProvider.gettingEntries == Status.loading ||
                    transactionProvider.gettingExpenses == Status.loading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  )
                : transactionProvider.monthlyBudget.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            "You did not create any budget for this month",
                            style: secondaryTextStyle(),
                          ),
                        ),
                      )
                    : Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 40),
                            child: Column(
                              children: [
                                Column(children: [
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: budgets.length,
                                    itemBuilder: (context, index) => BudgetTile(
                                      budget: budgets[index],
                                    ),
                                  )
                                ]),
                              ],
                            ),
                          ),
                        ),
                      )
          ],
        ),
      );
    });
  }
}

class BudgetTile extends StatelessWidget {
  const BudgetTile({
    super.key,
    required this.budget,
  });
  final Map<String, dynamic> budget;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
                // changes position of shadow
              ),
            ]),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                budget['name'],
                style: secondaryTextStyle(
                  fontSize: 13,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        budget['amount'],
                        style: boldTextStyle(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          budget['label_percentage'],
                          style: secondaryTextStyle(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      budget['total'],
                      style: secondaryTextStyle(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Stack(
                children: [
                  Container(
                    width: (getScreenWidth(context) - 40),
                    height: 4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Color(0xff67727d).withOpacity(0.1)),
                  ),
                  Container(
                    width:
                        (getScreenWidth(context) - 40) * budget['percentage'],
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: secondaryColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
