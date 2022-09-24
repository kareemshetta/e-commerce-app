import 'package:ecommerce_app/cubits/shop_cubit/shop_cubit.dart';
import 'package:ecommerce_app/cubits/shop_screen_cubit/shop_login_cubit.dart';
import 'package:ecommerce_app/cubits/shop_screen_cubit/shop_register_cubit.dart';
import 'package:ecommerce_app/screens/layout/home_screen.dart';
import 'package:ecommerce_app/screens/products_screen.dart';
import 'package:ecommerce_app/screens/register_screen.dart';
import 'package:ecommerce_app/screens/shop_login_screen.dart';
import 'package:ecommerce_app/styles/theme.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubits/app_cubit/app_state.dart';
import 'cubits/observer_cubit.dart';
import 'cubits/app_cubit/theme_cubit.dart';
import 'network/remote/dio_helper.dart';
import 'screens/onboarding_screen.dart';
import './network/local/cache_helper.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getBoolean(key: 'isDark');
  bool? onBoarding = await CacheHelper.getData('onBoarding') as bool?;
  dynamic token = await CacheHelper.getData('token');
  Widget screen;
  if (onBoarding!) {
    if (token != null) {
      screen = HomeScreen();
    } else {
      screen = LoginShopScreen();
    }
  } else {
    screen = OnBoardingScreen();
  }

  runApp(MyApp(isDark ?? false, screen, token ?? ''));
}

class MyApp extends StatelessWidget {
  const MyApp(this.isPrefDark, this.screen, this.token, {Key? key})
      : super(key: key);
  final bool isPrefDark;
  // final bool onBoarding;
  final Widget screen;
  final String token;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var tokenn = '';
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AppCubit()..isDark = isPrefDark,
        ),
        BlocProvider(
          create: (context) => ShopRegisterCubit()..token = token,
        ),
        BlocProvider(
          create: (context) => ShopLoginCubit(),
        ),
        BlocProvider(
          create: (context) => ShopCubit(token: token == '' ? tokenn : token)
            ..getHomeData(token)
            ..getCategoriesData()
            ..getAllFavouriteProducts()
            ..getUserProfile(),
        )
      ],
      child: BlocConsumer<AppCubit, AppState>(
        listener: (ctx, state) {},
        // ctx must match get(ctx)
        builder: (ctx, state) => MaterialApp(
          title: 'E-commerce',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode:
              AppCubit.get(ctx).isDark ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/',
          routes: {
            '/': (ctx) => screen,
            LoginShopScreen.routeName: (ctx) => LoginShopScreen(),
            HomeScreen.routeName: (ctx) => const HomeScreen(),
            OnBoardingScreen.routeName: (ctx) => const OnBoardingScreen(),
            ProductsScreen.routeName: (ctx) => const ProductsScreen(),
            RegisterShopScreen.routeName: (ctx) => RegisterShopScreen(),
          },
        ),
      ),
    );
  }
}
