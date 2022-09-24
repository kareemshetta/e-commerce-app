import 'package:bloc/bloc.dart';
import 'package:ecommerce_app/cubits/shop_screen_cubit/shop_login_state.dart';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:ecommerce_app/network/remote/dio_helper.dart';
import 'package:ecommerce_app/network/remote/end_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../network/local/cache_helper.dart';

class ShopLoginCubit extends Cubit<ShopLoginState> {
  ShopLoginCubit() : super(ShopLoginInitialState());
  static ShopLoginCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  bool isPassword = false;
  IconData visibilityIcon = Icons.visibility_off;
  void toggleVisibility() {
    isPassword = !isPassword;
    visibilityIcon = isPassword ? Icons.visibility : Icons.visibility_off;
    emit(ShopToggleVisibilityState());
  }

  String token = '';
  Future<dynamic> loginUser({
    required String email,
    required String password,
  }) async {
    emit(ShopLoginLoadingState());
    try {
      final response = await DioHelper.postData(
          lang: 'en',
          url: kLOGINUSER,
          data: {'email': email, 'password': password});

      print(response.data);
      final responseData = response.data;
      final userModel = UserLoginModel.fromJson(responseData);
      token = userModel.data!.token;

      CacheHelper.saveData(key: 'token', value: token);
      print('message${userModel.message}');
      emit(ShopLoginSuccessState(userModel));
      return responseData;
    } catch (err) {
      print(err);
      emit(ShopLoginErrorState());
    }
  }
}
