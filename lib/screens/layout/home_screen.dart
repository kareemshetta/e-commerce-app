import 'package:ecommerce_app/cubits/shop_cubit/shop_cubit.dart';
import 'package:ecommerce_app/cubits/shop_cubit/shop_state.dart';
import 'package:ecommerce_app/network/local/cache_helper.dart';
import 'package:ecommerce_app/screens/search_screen.dart';
import 'package:ecommerce_app/screens/shop_login_screen.dart';
import 'package:ecommerce_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/home-screen';
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {},
      builder: (context, state) {
        final shopCubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Salla'),
            actions: [
              IconButton(
                  onPressed: () async {
                    // final isCleared = await CacheHelper.clearData('token');
                    // print('isCleared:$isCleared');
                    // if (isCleared) {
                    //   navigateAndReplacementNamed(
                    //       context, null, LoginShopScreen.routeName);
                    navigateNamed(context, null, SearchScreen.routeName);
                    // }
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: shopCubit.items,
            currentIndex: shopCubit.currentIndex,
            onTap: shopCubit.changeBottomNavigation,
          ),
          body: shopCubit.screens[shopCubit.currentIndex],
        );
      },
    );
  }
}
