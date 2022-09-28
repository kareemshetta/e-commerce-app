import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ecommerce_app/cubits/shop_cubit/shop_state.dart';
import 'package:ecommerce_app/models/search_model.dart';
import 'package:ecommerce_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/shop_cubit/shop_cubit.dart';
import '../styles/colors.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  final searchController = TextEditingController();
  static const routeName = '/search-screen';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {},
      builder: (context, state) {
        final shopCubit = ShopCubit.get(context);
        final foundedProducts = shopCubit.foundedProducts;
        return Scaffold(
            appBar: AppBar(
              title: Text('search'),
              leading: IconButton(
                  onPressed: () {
                    ShopCubit.get(context).foundedProducts = [];
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
              child: Column(
                children: [
                  buildDefaultTextFormField(
                      controller: searchController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'you must type search text';
                        }
                        return null;
                      },
                      labelText: 'search',
                      prefixIcon: const Icon(Icons.search),
                      onSubmit: (_) {
                        shopCubit.getSearchData(searchController.text);
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  ConditionalBuilder(
                    condition: state is ShopSearchLoadingState,
                    fallback: (context) => Expanded(
                      child: foundedProducts.isEmpty
                          ? Center(
                              child: Text('search to get products'),
                            )
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  buildSearchedListItem(
                                      foundedProducts[index], context),
                              separatorBuilder: (context, index) {
                                return Divider(
                                  height: 1,
                                  thickness: 1,
                                  indent: 2,
                                  endIndent: 2,
                                  color: Colors.grey.shade400,
                                );
                              },
                              itemCount: foundedProducts.length),
                    ),
                    builder: (context) => Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}

Widget buildSearchedListItem(FoundedProduct foundedProd, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
    height: 400,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Image.network(
                  foundedProd.image,
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Expanded(
                child: Center(
                  child: Card(
                    color: Colors.grey.shade50,
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        foundedProd.description,
                        maxLines: 10,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                foundedProd.name,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                  height: 1,
                ),
              ),
              Row(
                children: [
                  Text(
                    'price: ',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 17),
                  ),
                  Text(
                    '${foundedProd.price}\$',
                    style: TextStyle(color: defaultColor, fontSize: 17),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    ),
  );
}
