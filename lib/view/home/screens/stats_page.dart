import 'package:budget_buddy/providers/auth_provider.dart';
import 'package:budget_buddy/providers/transactions_provider.dart';
import 'package:budget_buddy/utils/chart.dart';
import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:budget_buddy/utils/constants.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int activeMonth = 0;
  List<Map<String, dynamic>> months = [];
  final formatter = NumberFormat.compactCurrency(
    decimalDigits: 2,
    symbol: '₦',
  );

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
      context.read<TransactionsProvider>().getMonthly(
          userId: context.read<AuthProvider>().user!.uid, date: DateTime.now());
      context.read<TransactionsProvider>().getChartData(
          userId: context.read<AuthProvider>().user!.uid, date: DateTime.now());
    });
  }

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsProvider>(
        builder: (context, transactionProvider, child) {
      final totalExpenses = transactionProvider.monthlyExpenses
          .fold(0.00, (init, e) => init + e.amount);
      final totalIncome = transactionProvider.monthlyIncome
          .fold(0.00, (init, e) => init + e.amount);
      List expenses = [
        {
          "icon": Icons.arrow_back,
          "color": blue,
          "label": "Income",
          "cost": formatter.format(totalIncome),
        },
        {
          "icon": Icons.arrow_forward,
          "color": red,
          "label": "Expense",
          "cost": formatter.format(totalExpenses),
        }
      ];
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
                          "Stats",
                          style: boldTextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
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
                                transactionProvider.getMonthly(
                                    userId:
                                        context.read<AuthProvider>().user!.uid,
                                    date: months[index]['date']);
                                transactionProvider.getChartData(
                                    userId:
                                        context.read<AuthProvider>().user!.uid,
                                    date: months[index]['date']);
                              },
                              child: Container(
                                width:
                                    (MediaQuery.of(context).size.width - 40) /
                                        6,
                                child: Column(
                                  children: [
                                    Text(
                                      months[index]['label'],
                                      style: secondaryTextStyle(fontSize: 10),
                                    ),
                                    SizedBox(
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
                                          style: boldTextStyle(
                                              fontSize: 10,
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
            SizedBox(
              height: 20,
            ),
            transactionProvider.gettingMonthly == Status.loading ||
                    transactionProvider.gettingChartData == Status.loading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  )
                : transactionProvider.monthlyExpenses.isEmpty ||
                        transactionProvider.monthlyIncome.isEmpty
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Center(
                            child: Text(
                              "You have not recorded any income or expense this month ",
                              textAlign: TextAlign.center,
                              style: secondaryTextStyle(),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Container(
                              width: double.infinity,
                              height: 250,
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
                                padding: EdgeInsets.all(10),
                                child: Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Net balance",
                                            style: secondaryTextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "₦${(totalIncome - totalExpenses).abs()}",
                                            style: boldTextStyle(
                                              fontSize: 25,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Container(
                                        width: (getScreenWidth(context) - 20),
                                        height: 150,
                                        child: LineChart(
                                          mainData(transactionProvider.spots),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Wrap(
                              spacing: 20,
                              children: List.generate(expenses.length, (index) {
                                return Container(
                                  width: (getScreenWidth(context) - 60) / 2,
                                  height: 170,
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
                                    padding: const EdgeInsets.only(
                                        left: 25,
                                        right: 25,
                                        top: 20,
                                        bottom: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: expenses[index]['color']),
                                          child: Center(
                                              child: Icon(
                                            expenses[index]['icon'],
                                            color: white,
                                          )),
                                        ),
                                        smallVerticalSpace,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                expenses[index]['label'],
                                                style: secondaryTextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                expenses[index]['cost'],
                                                style: boldTextStyle(
                                                  fontSize: 20,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }))
                        ],
                      ),
          ],
        ),
      );
    });
  }
}
