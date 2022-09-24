import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/cubits/shop_screen_cubit/shop_register_state.dart';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:ecommerce_app/network/remote/dio_helper.dart';
import 'package:ecommerce_app/network/remote/end_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../network/local/cache_helper.dart';

class ShopRegisterCubit extends Cubit<ShopRegisterState> {
  ShopRegisterCubit() : super(ShopRegisterInitialState());
  static ShopRegisterCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  bool isPassword = false;
  IconData visibilityIcon = Icons.visibility_off;
  void toggleVisibility() {
    isPassword = !isPassword;
    visibilityIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(ShopRegisterToggleVisibilityState());
  }

  String token = '';
  UserLoginModel? userModel;
  Future<void> registerUser(
      {required String email,
      required String password,
      required String name,
      required String phoneNumber}) async {
    emit(ShopRegisterLoadingState());
    try {
      final response = await DioHelper.postData(
          lang: 'en',
          url: kRegister,
          data: {
            'email': email,
            'password': password,
            'name': name,
            'phone': phoneNumber
          });

      print(response.data);
      final responseData = response.data;
      userModel = UserLoginModel.fromJson(responseData);
      token = userModel!.data!.token;
      print('message${userModel!.message}');
      CacheHelper.saveData(key: 'token', value: token);
      emit(ShopRegisterSuccessState(userModel!));
      return responseData;
    } catch (err) {
      print(err);
      emit(ShopRegisterErrorState());
    }
  }
}
