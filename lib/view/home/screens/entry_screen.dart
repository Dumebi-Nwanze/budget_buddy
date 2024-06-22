import 'package:budget_buddy/json/create_budget_json.dart';
import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:budget_buddy/view/home/components/create_budget_component.dart';
import 'package:budget_buddy/view/home/components/create_tranaction_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreatBudgetPage extends StatefulWidget {
  @override
  _CreatBudgetPageState createState() => _CreatBudgetPageState();
}

class _CreatBudgetPageState extends State<CreatBudgetPage> {
  int selected = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selected == 0 ? "Create budget" : "Add entry",
          style: boldTextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (selected == 0) {
                  selected = 1;
                } else {
                  selected = 0;
                }
              });
            },
            icon: const Icon(CupertinoIcons.arrow_2_circlepath),
          ),
        ],
      ),
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (selected == 0) {
      return CreateBudgetComponent();
    } else {
      return CreateTranactionComponent();
    }
  }
}
