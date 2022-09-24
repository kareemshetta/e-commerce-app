import 'package:ecommerce_app/models/user_model.dart';

abstract class ShopLoginState {}

class ShopLoginLoadingState extends ShopLoginState {}

class ShopLoginSuccessState extends ShopLoginState {
  UserLoginModel model;
  ShopLoginSuccessState(this.model);
}

class ShopLoginErrorState extends ShopLoginState {}

class ShopLoginInitialState extends ShopLoginState {}

class ShopToggleVisibilityState extends ShopLoginState {}
