import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/cubits/shop_cubit/shop_state.dart';
import 'package:ecommerce_app/models/categories_model.dart';
import 'package:ecommerce_app/models/favourite_model.dart';
import 'package:ecommerce_app/models/favourite_products.dart';
import 'package:ecommerce_app/models/home_model.dart';
import 'package:ecommerce_app/models/search_model.dart';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:ecommerce_app/network/remote/dio_helper.dart';
import 'package:ecommerce_app/network/remote/end_points.dart';
import 'package:ecommerce_app/screens/categories_screen.dart';
import 'package:ecommerce_app/screens/favourites_screen.dart';
import 'package:ecommerce_app/screens/products_screen.dart';
import 'package:ecommerce_app/screens/settings_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopCubit extends Cubit<ShopState> {
  ShopCubit({required this.token}) : super(InitialShopState());
  String token;
  static ShopCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Home'),
    BottomNavigationBarItem(
        icon: Icon(Icons.category_outlined), label: 'Categories'),
    BottomNavigationBarItem(
        icon: Icon(Icons.favorite_outline), label: 'Favourites'),
    BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'settings'),
  ];
  List<Widget> screens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavouritesScreen(),
    SettingsScreen()
  ];

  int currentIndex = 0;
  void changeBottomNavigation(int index) async {
    currentIndex = index;
    emit(ChangeBottomNavigationState());
  }

  CategoriesModel? categoriesModel;

  void getCategoriesData() async {
    emit(ShopCategoriesLoadingState());
    try {
      final data = await DioHelper.getData(url: kCATEGORIES, lang: 'en');
      print(data);
      categoriesModel = CategoriesModel.fromJson(data.data);
      print(categoriesModel!.data.categories[0].name);
      emit(ShopCategoriesSuccessState());
    } catch (err) {
      print(err.toString());
      emit(ShopCategoriesErrorState());
    }
  }

  Map<int, bool> favourites = {};
  HomeModel? model;
  void getHomeData(String token) async {
    emit(ShopHomeLoadingState());
    try {
      final data =
          await DioHelper.getData(url: kHOME, token: token, lang: 'en');
      print(data.data);
      model = HomeModel.fromJson(data.data);
      final products = model!.homeDataModel.products;
      for (var element in products) {
        favourites.addAll({element.id: element.inFavourite});
      }

      emit(ShopHomeSuccessState());
    } catch (e) {
      print(e.toString());
      emit(ShopHomeErrorState());
    }
  }

  FavouriteModel? favouriteModel;
  void toggleFavourite({
    required int id,
  }) async {
    final oldFavourite = favourites[id];
    favourites[id] = !favourites[id]!;
    emit(ShopToggleFavouriteChangeState());
    try {
      final data = await DioHelper.postData(
          lang: 'en',
          url: kTOGGLEFAVOURITE,
          data: {'product_id': id},
          token: token);
      favouriteModel = FavouriteModel.fromJson(data.data);
      if (!favouriteModel!.status) {
        favourites[id] = oldFavourite!;
      }
      print(favouriteModel!.message);
      await getAllFavouriteProducts();
      emit(ShopToggleFavouriteSuccessState(favouriteModel!));
    } catch (error) {
      print(error);
      favourites[id] = oldFavourite!;
      emit(ShopToggleFavouriteErrorState());
    }
  }

  FavouriteProductsModel? favouriteProductsModel;
  Future<void> getAllFavouriteProducts() async {
    emit(ShopGetAllFavouriteLoadingState());
    try {
      final response = await DioHelper.getData(
        url: kGETALLFAVOURITE,
        token: token,
        lang: 'en',
      );
      final responseData = response.data;
      print('categoriesResponse:$responseData');
      favouriteProductsModel = FavouriteProductsModel.fromJson(responseData);
      emit(ShopGetAllFavouriteSuccessState());
    } catch (e) {
      print(e);
      emit(ShopGetAllFavouriteErrorState());
    }
  }

  UserLoginModel? profile;
  void getUserProfile() async {
    emit(ShopGetUserProfileLoadingState());

    try {
      final response =
          await DioHelper.getData(url: kPROFILE, lang: 'en', token: token);
      final responseData = response.data;
      profile = UserLoginModel.fromJson(responseData);
      print(profile!.data!.name);
      emit(ShopGetUserProfileSuccessState());
    } catch (e) {
      print(e);
      emit(ShopGetUserProfileErrorState());
      print(e);
    }
  }

  void updateUserProfile({
    required String name,
    required String email,
    required String phone,
  }) async {
    emit(ShopUpdateUserProfileLoadingState());

    try {
      final response = await DioHelper.putData(
        url: kGetProfile,
        lang: 'en',
        token: token,
        data: {
          'name': name,
          'phone': phone,
          'email': email,
        },
      );
      final responseData = response.data;
      profile = UserLoginModel.fromJson(responseData);
      print(profile!.data!.name);
      emit(
        ShopUpdateUserProfileSuccessState(),
      );
    } catch (e) {
      print(e);
      emit(
        ShopUpdateUserProfileErrorState(),
      );
      print(e);
    }
  }

  List<FoundedProduct> foundedProducts = [];

  Future<void> getSearchData(String searchText) async {
    foundedProducts = [];
    emit(ShopSearchLoadingState());
    try {
      final response = await DioHelper.postData(
          url: kGetSearch,
          token: token,
          lang: 'en',
          data: {'text': searchText});
      print(response.data);
      //print('isfavourite:${searchModel!.searchModelData.foundedProduct[0].isFavourite}');
      foundedProducts =
          SearchModel.fromJson(response.data).searchModelData.foundedProduct;
      print('isfavourite:${foundedProducts[0].isFavourite}');
      emit(ShopSearchSuccessState());
    } catch (err) {
      print(err);
      emit(ShopSearchErrorState());
    }
  }
}
