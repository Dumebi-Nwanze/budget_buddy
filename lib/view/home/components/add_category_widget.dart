import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddCategoryWidget extends StatelessWidget {
  const AddCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showAddCategoryDialog(context: context);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
        ),
        child: Container(
          margin: const EdgeInsets.only(
            left: 10,
          ),
          width: 150,
          height: 170,
          decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: grey.withOpacity(0.01),
                  spreadRadius: 10,
                  blurRadius: 3,
                ),
              ]),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 20, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: grey.withOpacity(0.15)),
                    child: const Center(
                      child: Icon(
                        Icons.add_rounded,
                        size: 40,
                      ),
                    )),
                Text(
                  "Add category",
                  style: boldTextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showAddCategoryDialog({required BuildContext context}) {
  showDialog(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: appWhite,
          ),
          padding: const EdgeInsets.all(12),
        );
      });
}
