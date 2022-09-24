import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ecommerce_app/cubits/shop_screen_cubit/shop_Register_cubit.dart';
import 'package:ecommerce_app/screens/layout/home_screen.dart';
import 'package:ecommerce_app/screens/shop_login_screen.dart';
import 'package:ecommerce_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/shop_screen_cubit/shop_register_state.dart';

class RegisterShopScreen extends StatelessWidget {
  RegisterShopScreen({Key? key}) : super(key: key);
  static const routeName = 'shopRegisterScreen';

  final passwordController = TextEditingController();
  final emailAddressController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  // bool isPass=false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopRegisterCubit, ShopRegisterState>(
      listener: (context, state) {
        if (state is ShopRegisterSuccessState) {
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
        final shopCubit = ShopRegisterCubit.get(context);
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
                        'Register',
                        style: Theme.of(context)
                            .textTheme
                            .headline4!
                            .copyWith(color: Colors.black),
                      ),
                      Text(
                        'Register now to browse our hot offers',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildDefaultTextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'you must enter name';
                            }
                            return null;
                          },
                          keyBoardType: TextInputType.emailAddress,
                          prefixIcon: Icon(Icons.person),
                          labelText: 'name'),
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
                        labelText: 'password',
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
                        onSubmit: (value) async {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      buildDefaultTextFormField(
                          controller: phoneController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'you must enter phone number';
                            }
                            return null;
                          },
                          keyBoardType: TextInputType.number,
                          prefixIcon: Icon(Icons.phone),
                          labelText: 'phone number'),
                      SizedBox(
                        height: 10,
                      ),
                      ConditionalBuilder(
                        condition: state is! ShopRegisterLoadingState,
                        builder: (ctx) {
                          return defaultButton(
                              onPressed: () async {
                                if (!formKey.currentState!.validate()) {
                                  return;
                                } else {
                                  await ShopRegisterCubit.get(context)
                                      .registerUser(
                                    email: emailAddressController.text,
                                    password: passwordController.text,
                                    name: nameController.text,
                                    phoneNumber: phoneController.text,
                                  );
                                }
                              },
                              buttonTitle: 'Register',
                              isUpper: true);
                        },
                        fallback: (ctx) {
                          return Center(child: CircularProgressIndicator());
                        },
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('you have an account?'),
                          buildDefaultTextButton(() {
                            navigateAndReplacementNamed(
                                context: context,
                                routeName: LoginShopScreen.routeName);
                          }, 'login')
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
