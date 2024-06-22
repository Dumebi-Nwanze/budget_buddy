import 'package:budget_buddy/json/create_budget_json.dart';
import 'package:budget_buddy/models/budget_model.dart';
import 'package:budget_buddy/models/category_model.dart';
import 'package:budget_buddy/providers/auth_provider.dart';
import 'package:budget_buddy/providers/transactions_provider.dart';
import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:budget_buddy/utils/common_widgets.dart';
import 'package:budget_buddy/utils/constants.dart';
import 'package:budget_buddy/view/home/components/categories_list_component.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateBudgetComponent extends StatefulWidget {
  const CreateBudgetComponent({super.key});

  @override
  State<CreateBudgetComponent> createState() => _CreateBudgetComponentState();
}

class _CreateBudgetComponentState extends State<CreateBudgetComponent> {
  TextEditingController budgetName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController budgetPrice = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  DateTime startDate = DateTime.now();
  Category? selectedCategory;

  final dateFormatter = DateFormat('EEEE d MMMM yyyy');

  List<Category> categories = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile = context.read<AuthProvider>().user;
      if (userProfile != null) {
        categories.addAll(defaultCategories.where((c) => c.id != "13"));
        categories.addAll(userProfile.categories);
      } else {
        categories.addAll(defaultCategories);
      }
      selectedCategory = categories[0];
      setState(() {});
    });
  }

  showDatePicker() {
    showDateRangePicker(
            initialDateRange:
                DateTimeRange(start: DateTime.now(), end: endDate),
            context: context,
            currentDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 1825)))
        .then((val) => {
              setState(() {
                if (val != null) {
                  endDate = val.end;
                }
              })
            });
  }

  clearForm() {
    budgetName.clear();
    budgetPrice.clear();
    description.clear();
    selectedCategory = defaultCategories[0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<TransactionsProvider, AuthProvider>(
        builder: (context, transactionProvider, authProvider, child) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: Text(
                "Choose category",
                style: boldTextStyle(fontSize: 16),
              ),
            ),
            largeVerticalSpace,
            CategoriesListComponent(
                onSelected: (cat) {
                  setState(() {
                    selectedCategory = cat;
                  });
                },
                categories: categories),
            xxlargeVerticalSpace,
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Budget name",
                      style: secondaryTextStyle(),
                    ),
                    mediumVerticalSpace,
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                      controller: budgetName,
                      cursorColor: black,
                      style: boldTextStyle(fontSize: 17),
                      decoration: InputDecoration(
                        hintStyle: boldTextStyle(
                          fontSize: 17,
                          color: text2,
                        ),
                        hintText: "Enter Budget Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: textFieldbg,
                      ),
                    ),
                    largeVerticalSpace,
                    Text(
                      "Enter description",
                      style: secondaryTextStyle(),
                    ),
                    mediumVerticalSpace,
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: description,
                      style: boldTextStyle(
                        fontSize: 14,
                      ),
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintStyle: boldTextStyle(
                          fontSize: 17,
                          color: text2,
                        ),
                        hintText: "Enter Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: textFieldbg,
                      ),
                    ),
                    mediumVerticalSpace,
                    Text(
                      "Select end date",
                      style: secondaryTextStyle(),
                    ),
                    mediumVerticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dateFormatter.format(endDate),
                          style: boldTextStyle(fontSize: 14),
                        ),
                        InkWell(
                          onTap: () {
                            showDatePicker();
                          },
                          child: Text(
                            "CHANGE DATE",
                            style: secondaryTextStyle(
                                fontSize: 14, underline: true),
                          ),
                        )
                      ],
                    ),
                    mediumVerticalSpace,
                    Text(
                      "Enter amount (₦)",
                      style: secondaryTextStyle(),
                    ),
                    mediumVerticalSpace,
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'This feild is required';
                        }
                        if (int.parse(val) <= 0) {
                          return 'Amount must be a value greater than 0.00';
                        }
                        return null;
                      },
                      controller: budgetPrice,
                      style: boldTextStyle(
                        fontSize: 17,
                      ),
                      decoration: InputDecoration(
                        hintStyle: boldTextStyle(
                          fontSize: 17,
                          color: text2,
                        ),
                        hintText: "Enter Amount (eg. ₦5000)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: textFieldbg,
                      ),
                    ),
                    largeVerticalSpace,
                    largeVerticalSpace,
                    InkWell(
                      onTap: () async {
                        dismissKeyboard();
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        final budget = Budget(
                          id: const Uuid().v4(),
                          name: budgetName.text.trim(),
                          description: description.text.trim() == ""
                              ? "No Description"
                              : description.text.trim(),
                          amount: double.parse(budgetPrice.text.trim()) * 1.00,
                          category: selectedCategory ?? categories.first,
                          createdAt: DateTime.now(),
                          startDate: startDate,
                          endDate: endDate,
                        );

                        await transactionProvider.addBudget(
                            budget: budget, userId: authProvider.user!.uid);
                        if (context.mounted) {
                          if (transactionProvider.addingBudget ==
                              Status.success) {
                            appToast(transactionProvider.message);
                            clearForm();
                          } else {
                            appToast(transactionProvider.message);
                          }
                        }
                      },
                      child: Container(
                        width: getScreenWidth(context),
                        height: 50,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Text(
                            transactionProvider.addingBudget == Status.loading
                                ? "Please wait..."
                                : "Create budget",
                            style: boldTextStyle(color: appWhite, fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    largeVerticalSpace,
                    largeVerticalSpace,
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}
