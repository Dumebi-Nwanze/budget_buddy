import 'package:budget_buddy/json/daily_json.dart';
import 'package:budget_buddy/models/entry_model.dart';
import 'package:budget_buddy/providers/auth_provider.dart';
import 'package:budget_buddy/providers/transactions_provider.dart';
import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyPage extends StatefulWidget {
  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int activeDay = 0;
  List<Map<String, dynamic>> days = [];
  void generateDates() {
    DateTime today = DateTime.now();
    for (int i = 30; i >= 0; i--) {
      DateTime date = today.subtract(Duration(days: i));
      days.add({
        'label': DateFormat('E').format(date),
        'day': DateFormat('d').format(date),
        'date': date,
      });
    }
    setState(() {
      activeDay = days.length - 1;
    });
  }

  @override
  void initState() {
    super.initState();
    generateDates();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionsProvider>().getEntries(
          userId: context.read<AuthProvider>().user!.uid, date: DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactionsProvider, AuthProvider>(
        builder: (context, transactionProvider, authProvider, child) {
      final total = transactionProvider.dailyEntries.fold(0.00, (init, entry) {
        return init + entry.amount;
      });

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
                          "Daily Transaction",
                          style: boldTextStyle(fontSize: 20),
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
                          children: List.generate(days.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  activeDay = index;
                                });
                                //logger.d(days[index]["date"]);
                                transactionProvider.getEntries(
                                  userId: authProvider.user!.uid,
                                  date: days[index]["date"],
                                );
                              },
                              child: Container(
                                width:
                                    (MediaQuery.of(context).size.width - 40) /
                                        7,
                                child: Column(
                                  children: [
                                    Text(
                                      days[index]['label'],
                                      style: secondaryTextStyle(fontSize: 10),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: activeDay == index
                                              ? secondaryColor
                                              : Colors.transparent,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: activeDay == index
                                                  ? secondaryColor
                                                  : grey)),
                                      child: Center(
                                        child: Text(
                                          days[index]['day'],
                                          style: boldTextStyle(
                                              fontSize: 10,
                                              color: activeDay == index
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
              height: 30,
            ),
            transactionProvider.gettingEntries == Status.loading
                ? const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    ),
                  )
                : transactionProvider.dailyEntries.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            "You have not recorded any transactions today",
                            style: secondaryTextStyle(),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          SizedBox(
                            height: getScreenHeight(context) * 0.5,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: transactionProvider
                                          .dailyEntries.length,
                                      itemBuilder: (context, index) =>
                                          ExpenseTile(
                                        entry: transactionProvider
                                            .dailyEntries[index],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Text(
                                  "Total",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: black.withOpacity(0.4),
                                      fontWeight: FontWeight.w600),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Spacer(),
                                Text(
                                  "₦${total}",
                                  style: boldTextStyle(
                                    fontSize: 20,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
          ],
        ),
      );
    });
  }
}

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({
    super.key,
    required this.entry,
  });

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: (getScreenWidth(context) - 40) * 0.7,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: grey.withOpacity(0.1),
                    ),
                    child: Center(
                      child: Image.asset(
                        entry.category.icon,
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    width: (getScreenWidth(context) - 90) * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.name,
                          style: boldTextStyle(
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          DateFormat('h:mm a').format(entry.createdAt),
                          style: secondaryTextStyle(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: (getScreenWidth(context) - 40) * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "₦${entry.amount}",
                    style: boldTextStyle(fontSize: 15, color: Colors.green),
                  ),
                ],
              ),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 65, top: 8),
          child: Divider(
            thickness: 0.8,
          ),
        )
      ],
    );
  }
}
