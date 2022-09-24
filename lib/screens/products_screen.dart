import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ecommerce_app/cubits/shop_cubit/shop_cubit.dart';
import 'package:ecommerce_app/cubits/shop_cubit/shop_state.dart';
import 'package:ecommerce_app/models/categories_model.dart';
import 'package:ecommerce_app/models/home_model.dart';
import 'package:ecommerce_app/styles/colors.dart';
import 'package:ecommerce_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);
  static const routeName = 'products-screen';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(listener: (context, state) {
      if (state is ShopToggleFavouriteSuccessState) {
        if (state.model.status) {
          buildToast(state.model.message, Colors.green);
        } else {
          // buildToast(state.model.message, Colors.red);
        }
      }
    }, builder: (context, state) {
      final shopCubit = ShopCubit.get(context);
      print('rebuillllllllllllllld');
      return Scaffold(
          body: ConditionalBuilder(
        condition:
            (shopCubit.model != null && shopCubit.categoriesModel != null),
        builder: (context) {
          return buildProductItem(
              shopCubit.model!, shopCubit.categoriesModel!, context);
        },
        fallback: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ));
    });
  }
}

Widget buildProductItem(
    HomeModel model, CategoriesModel categoriesModel, BuildContext context) {
  return SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CarouselSlider(
        items: model.homeDataModel.banners
            .map(
              (bannerModel) => ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  bannerModel.img,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            )
            .toList(),
        options: CarouselOptions(
            height: 150,
            autoPlay: true,
            viewportFraction: 1,
            initialPage: 0,
            autoPlayAnimationDuration: Duration(seconds: 1),
            autoPlayCurve: Curves.fastOutSlowIn,
            autoPlayInterval: Duration(seconds: 3),
            enableInfiniteScroll: true,
            scrollDirection: Axis.horizontal,
            reverse: false),
      ),
      SizedBox(
        height: 5,
      ),
      buildHorizontalDivider(),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            Container(
              height: 140,
              child: ListView.separated(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return buildCategoryListItem(
                        categoriesModel.data.categories[index]);
                  },
                  separatorBuilder: (ctx, index) {
                    return SizedBox(
                      width: 5,
                    );
                  },
                  itemCount: categoriesModel.data.categories.length),
            ),
            SizedBox(
              height: 10,
            ),
            buildHorizontalDivider(),
            Text(
              'Products',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
      GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: 10,
        ),
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 1,
        children: List.generate(
          model.homeDataModel.products.length,
          (index) {
            return buildProductGridViewItem(
                model.homeDataModel.products[index], context);
          },
        ),
      )
    ]),
  );
}

Widget buildHorizontalDivider() {
  return Container(
    width: double.infinity,
    height: 1,
    color: Colors.grey[300],
  );
}

Widget buildProductGridViewItem(ProductModel model, BuildContext context) {
  print('rebilddddd');
  return Column(
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
                child: Image.network(model.img),
              ),
            ),
            if (model.discount > 0)
              Container(
                color: Colors.red,
                child: Text(
                  ' Discount ${model.discount.toString()}%',
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
        model.name,
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
              '${model.price}\$',
              style: TextStyle(color: defaultColor, fontSize: 16),
            ),
            SizedBox(
              width: 5,
            ),
            if (model.discount > 0)
              Text(
                '${model.oldPrice}\$',
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
                  id: model.id,
                );
              },
              icon: Icon(
                shadows: [
                  Shadow(
                      color:
                          ShopCubit.get(context).favourites[model.id] ?? false
                              ? Colors.red
                              : Colors.grey,
                      offset: Offset(0, 0),
                      blurRadius: 20)
                ],
                Icons.favorite,
                color: ShopCubit.get(context).favourites[model.id] ?? false
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
  );
}

Widget buildCategoryListItem(Category category) {
  return Container(
    height: 140,
    width: 120,
    child: Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Image.network(
          category.image,
          fit: BoxFit.cover,
        ),
        Container(
          width: double.infinity,
          color: Colors.black.withOpacity(0.70),
          child: Text(
            category.name,
            style: TextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ),
  );
}
