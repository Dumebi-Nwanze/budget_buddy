import 'package:budget_buddy/models/entry_model.dart';
import 'package:budget_buddy/providers/auth_provider.dart';
import 'package:budget_buddy/providers/transactions_provider.dart';
import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:budget_buddy/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transProvider = context.read<TransactionsProvider>();
      final authProvider = context.read<AuthProvider>();

      transProvider.getAllTime(userId: authProvider.user!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, TransactionsProvider>(
        builder: (context, authProvider, transactionProvider, child) {
      List<Entry> allTimeExpenses = transactionProvider.allTimeExpenses;
      List<Entry> allTimeIncome = transactionProvider.allTimeIncome;

      double expenses =
          allTimeExpenses.fold(0.00, (init, e) => init + e.amount);
      double income = allTimeIncome.fold(0.00, (init, e) => init + e.amount);
      double ratio = (expenses == 0)
          ? income.clamp(0.0, 1.0)
          : (income / expenses).clamp(0.0, 1.0);
      int creditScore = calculateCreditScore(ratio);
      return Scaffold(
        backgroundColor: grey.withOpacity(0.05),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      top: 60, right: 16, left: 16, bottom: 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Profile",
                            style: boldTextStyle(
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authProvider.logOut();
                              if (context.mounted) {
                                context.goNamed("signin_screen");
                              }
                            },
                            icon: const Icon(CupertinoIcons.arrow_right_square),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              RotatedBox(
                                quarterTurns: -2,
                                child: CircularPercentIndicator(
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: grey.withOpacity(0.3),
                                    radius: 55.0,
                                    lineWidth: 6.0,
                                    percent: ratio,
                                    progressColor: secondaryColor),
                              ),
                              Container(
                                width: 85,
                                height: 85,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image:
                                            AssetImage("assets/images/man.jpg"),
                                        fit: BoxFit.cover)),
                              )
                            ],
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authProvider.user!.displayName,
                                style: boldTextStyle(fontSize: 20),
                              ),
                              mediumVerticalSpace,
                              Text(
                                "Credit score: ${creditScore}",
                                style: secondaryTextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      largeVerticalSpace,
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [primaryColor, secondaryColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.45, 0.75]),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withOpacity(0.01),
                                spreadRadius: 10,
                                blurRadius: 3,
                                // changes position of shadow
                              ),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 25, bottom: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Net Balance",
                                    style: secondaryTextStyle(
                                        fontSize: 12, color: white),
                                  ),
                                  smallVerticalSpace,
                                  Text(
                                    "₦${(income - expenses).abs()}",
                                    style: boldTextStyle(
                                        fontSize: 20, color: white),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  transactionProvider.getAllTime(
                                      userId: authProvider.user!.uid);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: white)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(13.0),
                                    child: Text(
                                      "Update",
                                      style: TextStyle(color: white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              xxlargeVerticalSpace,
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Email",
                      style: secondaryTextStyle(),
                    ),
                    smallVerticalSpace,
                    Text(
                      authProvider.user!.email,
                      style: boldTextStyle(fontSize: 16),
                    ),
                    largeVerticalSpace,
                    Text(
                      "Total Expenses",
                      style: secondaryTextStyle(),
                    ),
                    smallVerticalSpace,
                    Text(
                      " ₦${expenses}",
                      style: boldTextStyle(fontSize: 16),
                    ),
                    largeVerticalSpace,
                    Text(
                      "Total Income",
                      style: secondaryTextStyle(),
                    ),
                    smallVerticalSpace,
                    Text(
                      " ₦${income}",
                      style: boldTextStyle(fontSize: 16),
                    ),
                    xxlargeVerticalSpace,
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
