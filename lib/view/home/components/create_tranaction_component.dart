import 'package:budget_buddy/json/create_budget_json.dart';
import 'package:budget_buddy/models/category_model.dart';
import 'package:budget_buddy/models/entry_model.dart';
import 'package:budget_buddy/providers/auth_provider.dart';
import 'package:budget_buddy/providers/transactions_provider.dart';
import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:budget_buddy/utils/common_widgets.dart';
import 'package:budget_buddy/utils/constants.dart';
import 'package:budget_buddy/view/home/components/categories_list_component.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CreateTranactionComponent extends StatefulWidget {
  const CreateTranactionComponent({super.key});

  @override
  State<CreateTranactionComponent> createState() =>
      _CreateTranactionComponentState();
}

class _CreateTranactionComponentState extends State<CreateTranactionComponent> {
  Category? selectedCategory;

  List<Category> categories = [];
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController amount = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String _selectedType = 'Income';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile = context.read<AuthProvider>().user;
      if (userProfile != null) {
        categories.addAll(defaultCategories);
        categories.addAll(userProfile.categories);
      } else {
        categories.addAll(defaultCategories);
      }
      selectedCategory = categories[0];
      setState(() {});
    });
  }

  clearForm() {
    name.clear();
    amount.clear();
    description.clear();
    selectedCategory = defaultCategories[0];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, TransactionsProvider>(
        builder: (context, authProvider, transactionProvider, child) {
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
                      "Entry name",
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
                      controller: name,
                      style: boldTextStyle(fontSize: 17),
                      decoration: InputDecoration(
                        hintStyle: boldTextStyle(
                          fontSize: 17,
                          color: text2,
                        ),
                        hintText: "Enter entry Name",
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
                      "Select an option",
                      style: secondaryTextStyle(),
                    ),
                    mediumVerticalSpace,
                    Wrap(
                      spacing: 20.0, // spacing between radio buttons
                      children: [
                        LabeledRadio(
                          label: 'Income',
                          value: 'Income',
                          groupValue: _selectedType,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedType = newValue!;
                            });
                          },
                        ),
                        LabeledRadio(
                          label: 'Expense',
                          value: 'Expense',
                          groupValue: _selectedType,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedType = newValue!;
                            });
                          },
                        ),
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
                      controller: amount,
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
                        final entry = Entry(
                          id: const Uuid().v4(),
                          type: _selectedType.trim(),
                          name: name.text.trim(),
                          description: description.text.trim() == ""
                              ? "No Description"
                              : description.text.trim(),
                          category: selectedCategory ?? defaultCategories[0],
                          amount: double.parse(amount.text.trim()),
                          createdAt: DateTime.now(),
                        );

                        await transactionProvider.addEntry(
                            entry: entry, userId: authProvider.user!.uid);
                        if (context.mounted) {
                          if (transactionProvider.addingEntry ==
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
                            transactionProvider.addingEntry == Status.loading
                                ? "Please wait..."
                                : "Add entry",
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

class LabeledRadio extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final Function(String?) onChanged;

  const LabeledRadio({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(value);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          Text(label),
        ],
      ),
    );
  }
}
