import 'package:budget_buddy/models/category_model.dart';
import 'package:budget_buddy/utils/colors.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:flutter/material.dart';

class CategoriesListComponent extends StatefulWidget {
  CategoriesListComponent({
    super.key,
    required this.onSelected,
    required this.categories,
  });
  void Function(Category)? onSelected;
  List<Category> categories;

  @override
  State<CategoriesListComponent> createState() =>
      _CategoriesListComponentState();
}

class _CategoriesListComponentState extends State<CategoriesListComponent> {
  int activeCategory = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        ...List.generate(widget.categories.length, (index) {
          return GestureDetector(
            onTap: () {
              widget.onSelected!(widget.categories[index]);
              setState(() {
                activeCategory = index;
              });
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
                    border: Border.all(
                        width: 2,
                        color: activeCategory == index
                            ? secondaryColor
                            : Colors.transparent),
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
                      left: 25, right: 25, top: 20, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: grey.withOpacity(0.15)),
                          child: Center(
                            child: Image.asset(
                              widget.categories[index].icon,
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          )),
                      Text(
                        widget.categories[index].name,
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
        }),
      ]),
    );
  }
}
