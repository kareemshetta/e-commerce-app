import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ecommerce_app/cubits/shop_cubit/shop_cubit.dart';
import 'package:ecommerce_app/cubits/shop_cubit/shop_state.dart';
import 'package:ecommerce_app/models/favourite_products.dart';
import 'package:ecommerce_app/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../styles/colors.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build:favvvvvvvvvvvvv');

    return BlocConsumer<ShopCubit, ShopState>(
        listener: (context, state) {},
        builder: (context, state) {
          final favProducts = ShopCubit.get(context)
              .favouriteProductsModel!
              .data
              .favouriteProducts;
          return Scaffold(
              body: ConditionalBuilder(
            condition: state is! ShopGetAllFavouriteLoadingState,
            fallback: (ctx) => Center(child: CircularProgressIndicator()),
            builder: (ctx) => ListView.separated(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(15),
                itemBuilder: (context, index) {
                  return buildFavouriteListItem(favProducts[index], context);
                },
                separatorBuilder: (context, index) {
                  return buildHorizontalDivider();
                },
                itemCount: favProducts.length),
          ));
        });
  }
}

Widget buildFavouriteListItem(FavouriteProduct favProd, BuildContext context) {
  return Container(
    height: 300,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Center(
                  child: Image.network(
                    favProd.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (favProd.discount > 0)
                Container(
                  color: Colors.red,
                  child: Text(
                    ' Discount ${favProd.discount.toString()}%',
                    style: TextStyle(color: Colors.white),
                  ),
                )
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          favProd.name,
          maxLines: 2,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
            height: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            children: [
              Text(
                '${favProd.price}\$',
                style: TextStyle(color: defaultColor, fontSize: 16),
              ),
              SizedBox(
                width: 5,
              ),
              if (favProd.discount > 0)
                Text(
                  '${favProd.oldPrice}\$',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              Spacer(),
              IconButton(
                onPressed: () {
                  ShopCubit.get(context).toggleFavourite(
                    id: favProd.id,
                  );
                },
                icon: Icon(
                  shadows: [
                    Shadow(
                        color: ShopCubit.get(context).favourites[favProd.id] ??
                                false
                            ? Colors.red
                            : Colors.grey,
                        offset: Offset(0, 0),
                        blurRadius: 20)
                  ],
                  Icons.favorite,
                  color: ShopCubit.get(context).favourites[favProd.id] ?? false
                      ? Colors.red
                      : Colors.white
                  // ? Colors.red
                  // : Colors.grey[300]
                  ,
                ),
              )
            ],
          ),
        )
      ],
    ),
  );
}
