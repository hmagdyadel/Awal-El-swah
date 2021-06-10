import '../widgets/category_item.dart';
import '../widgets/dummy_data.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio:3 / 2,
          mainAxisExtent: 110,
          crossAxisSpacing:10,
        ),
        padding: EdgeInsets.all(25),
        children: DUMMY_CATEGORIES
            .map(
              (catData) => CategoryItem(
                id: catData.id,
                name: catData.name,
                color: catData.color,
              ),
            )
            .toList(),
      ),
    );
  }
}
