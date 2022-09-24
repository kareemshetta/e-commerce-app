import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../network/local/cache_helper.dart';
import 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(InitialState());

  static AppCubit get(BuildContext context) {
    return BlocProvider.of(context);
  }

  ThemeMode themMode = ThemeMode.light;
  bool isDark = false;

  void changeTheme() async {
    isDark = !isDark;
    await CacheHelper.setBoolean(key: 'isDark', value: isDark);
    emit(NewsChangeAppThemeState());
  }
}
