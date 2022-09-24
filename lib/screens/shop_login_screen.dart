import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ecommerce_app/cubits/shop_screen_cubit/shop_login_cubit.dart';
import 'package:ecommerce_app/cubits/shop_screen_cubit/shop_login_state.dart';
import 'package:ecommerce_app/models/user_model.dart';
import 'package:ecommerce_app/screens/layout/home_screen.dart';
import 'package:ecommerce_app/screens/register_screen.dart';
import 'package:ecommerce_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../network/local/cache_helper.dart';

class LoginShopScreen extends StatelessWidget {
  LoginShopScreen({Key? key}) : super(key: key);
  static const routeName = 'shoplogin';

  final passwordController = TextEditingController();
  final emailAddressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // bool isPass=false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopLoginCubit, ShopLoginState>(
      listener: (context, state) {
        if (state is ShopLoginSuccessState) {
          if (state.model.status) {
            print(state.model.data!.name);
            print(state.model.data!.token);
            buildToast(state.model.message, Colors.green);

            navigateAndReplacementNamed(
                context: context, routeName: HomeScreen.routeName);
          } else {
            print(state.model.message);
            buildToast(state.model.message, Colors.red);
          }
        }
      },
      builder: (context, state) {
        final shopCubit = ShopLoginCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LOGIN',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        'login now to browse our hot offers',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildDefaultTextFormField(
                          controller: emailAddressController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'you must enter email address';
                            }
                            return null;
                          },
                          keyBoardType: TextInputType.emailAddress,
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: 'email address'),
                      SizedBox(
                        height: 10,
                      ),
                      buildDefaultTextFormField(
                          keyBoardType: TextInputType.visiblePassword,
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                shopCubit.toggleVisibility();
                              },
                              icon: Icon(shopCubit.visibilityIcon)),
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'you must enter password';
                            }
                            return null;
                          },
                          isPassword: shopCubit.isPassword,
                          onSubmit: (value) async {
                            if (!formKey.currentState!.validate()) {
                              return;
                            } else {
                              final data = await ShopLoginCubit.get(context)
                                  .loginUser(
                                      email: emailAddressController.text,
                                      password: passwordController.text);
                            }
                          },
                          labelText: 'password'),
                      SizedBox(
                        height: 20,
                      ),
                      ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (ctx) {
                            return defaultButton(
                                onPressed: () async {
                                  if (!formKey.currentState!.validate()) {
                                    return;
                                  } else {
                                    await ShopLoginCubit.get(context).loginUser(
                                        email: emailAddressController.text,
                                        password: passwordController.text);
                                  }
                                },
                                buttonTitle: 'login',
                                isUpper: true);
                          },
                          fallback: (ctx) {
                            return Center(child: CircularProgressIndicator());
                          }),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account?'),
                          buildDefaultTextButton(() {
                            navigateAndReplacementNamed(
                                context: context,
                                routeName: RegisterShopScreen.routeName);
                          }, 'register')
                        ],
                      )
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
