import '../../models/favourite_model.dart';

abstract class ShopState {}

class InitialShopState extends ShopState {}

class ChangeBottomNavigationState extends ShopState {}

class ShopHomeLoadingState extends ShopState {}

class ShopHomeSuccessState extends ShopState {}

class ShopHomeErrorState extends ShopState {}

class ShopGetAllFavouriteLoadingState extends ShopState {}

class ShopGetAllFavouriteSuccessState extends ShopState {}

class ShopGetAllFavouriteErrorState extends ShopState {}

class ShopCategoriesSuccessState extends ShopState {}

class ShopCategoriesErrorState extends ShopState {}

class ShopCategoriesLoadingState extends ShopState {}

class ShopToggleFavouriteSuccessState extends ShopState {
  FavouriteModel model;
  ShopToggleFavouriteSuccessState(this.model);
}

class ShopToggleFavouriteChangeState extends ShopState {}

class ShopToggleFavouriteErrorState extends ShopState {}

class ShopToggleFavouriteLoadingState extends ShopState {}

class ShopGetUserProfileSuccessState extends ShopState {}

class ShopGetUserProfileErrorState extends ShopState {}

class ShopGetUserProfileLoadingState extends ShopState {}

class ShopUpdateUserProfileSuccessState extends ShopState {}

class ShopUpdateUserProfileErrorState extends ShopState {}

class ShopUpdateUserProfileLoadingState extends ShopState {}

class ShopSearchSuccessState extends ShopState {}

class ShopSearchErrorState extends ShopState {}

class ShopSearchLoadingState extends ShopState {}
