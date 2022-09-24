import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ecommerce_app/cubits/shop_cubit/shop_cubit.dart';
import 'package:ecommerce_app/network/local/cache_helper.dart';
import 'package:ecommerce_app/screens/shop_login_screen.dart';
import 'package:ecommerce_app/styles/colors.dart';
import 'package:ecommerce_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/shop_cubit/shop_state.dart';

class SettingsScreen extends StatelessWidget {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobilePhoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopState>(
      listener: (context, state) {},
      builder: (context, state) {
        final userProfile = ShopCubit.get(context).profile;
        nameController.text = userProfile!.data!.name;
        emailController.text = userProfile.data!.email;
        mobilePhoneController.text = userProfile.data!.phone;
        return ConditionalBuilder(
          condition: userProfile != null,
          fallback: (context) => Center(child: CircularProgressIndicator()),
          builder: (context) => Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (state is ShopUpdateUserProfileLoadingState)
                        const LinearProgressIndicator(),
                      SizedBox(
                        height: 5,
                      ),
                      buildDefaultTextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your name';
                          }
                          return null;
                        },
                        labelText: 'name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildDefaultTextFormField(
                        controller: mobilePhoneController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your mobile number';
                          }
                          return null;
                        },
                        labelText: 'mobile number',
                        prefixIcon: Icon(Icons.phone_enabled_outlined),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildDefaultTextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter email address';
                          }
                          return null;
                        },
                        labelText: 'email address',
                        prefixIcon: Icon(Icons.email),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      defaultButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            ShopCubit.get(context).updateUserProfile(
                              name: nameController.text,
                              email: emailController.text,
                              phone: mobilePhoneController.text,
                            );
                          },
                          buttonTitle: 'update',
                          isUpper: true),
                      SizedBox(
                        height: 30,
                      ),
                      defaultButton(
                        onPressed: () {
                          CacheHelper.clearData('token');
                          navigateAndReplacementNamed(
                              context: context,
                              routeName: LoginShopScreen.routeName);
                        },
                        buttonTitle: 'logout',
                        isUpper: true,
                        color: defaultColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
