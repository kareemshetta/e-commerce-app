import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ecommerce_app/cubits/shop_cubit/shop_cubit.dart';
import 'package:ecommerce_app/cubits/shop_cubit/shop_state.dart';
import 'package:ecommerce_app/screens/products_screen.dart';
import 'package:ecommerce_app/styles/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/categories_model.dart' as cat;

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {},
      builder: (context, state) {
        final categoryModel = ShopCubit.get(context).categoriesModel;
        final cateList =
            ShopCubit.get(context).categoriesModel!.data.categories;
        return Scaffold(
          body: ConditionalBuilder(
              condition: categoryModel != null,
              builder: (context) {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      return buildCatListItem(cateList[index]);
                    },
                    separatorBuilder: (context, index) =>
                        buildHorizontalDivider(),
                    itemCount: cateList.length);
              },
              fallback: (context) => const Center(
                    child: CircularProgressIndicator(),
                  )),
        );
      },
    );
  }

  Padding buildCatListItem(cat.Category category) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(children: [
        Image.network(
          category.image,
          fit: BoxFit.cover,
          height: 120,
          width: 120,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          category.name,
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Icon(
          Icons.arrow_forward_ios_outlined,
          color: defaultColor,
        )
      ]),
    );
  }
}
