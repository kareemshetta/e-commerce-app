import 'package:ecommerce_app/models/user_model.dart';

abstract class ShopRegisterState {}

class ShopRegisterLoadingState extends ShopRegisterState {}

class ShopRegisterSuccessState extends ShopRegisterState {
  UserLoginModel model;
  ShopRegisterSuccessState(this.model);
}

class ShopRegisterErrorState extends ShopRegisterState {}

class ShopRegisterInitialState extends ShopRegisterState {}

class ShopRegisterToggleVisibilityState extends ShopRegisterState {}
