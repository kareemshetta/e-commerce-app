import 'package:ecommerce_app/screens/shop_login_screen.dart';
import 'package:ecommerce_app/styles/colors.dart';
import 'package:ecommerce_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../network/local/cache_helper.dart';

class PageModel {
  final String img;
  final String title;
  final String body;
  PageModel(this.title, this.body, this.img);
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);
  static const routeName = 'on-boarding';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isLast = false;
  final pageController = PageController();

  List<PageModel> data = [
    PageModel('shopping 1', 'body1', 'assets/images/shopping-bag.png'),
    PageModel('shopping 2', 'body2', 'assets/images/shopping-bag.png'),
    PageModel('shopping 3', 'body3', 'assets/images/shopping-bag.png'),
  ];
  void submit() async {
    final isSaved = await CacheHelper.saveData(key: 'onBoarding', value: true);
    if (isSaved) {
      navigateAndReplace(context, LoginShopScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          buildDefaultTextButton(() {
            submit();
          }, 'skip')
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: data.length,
                itemBuilder: (ctx, index) {
                  return buildPageViewContent(data[index]);
                },
                physics: const BouncingScrollPhysics(),
                onPageChanged: (int pageIndex) {
                  print(pageIndex);
                  print(data.length - 1);
                  if (pageIndex == data.length - 1) {
                    setState(() {
                      isLast = true;
                    });
                  } else {
                    setState(() {
                      isLast = false;
                    });
                    print(isLast);
                  }
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: data.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: defaultColor,
                    dotHeight: 10,
                    expansionFactor: 4,
                    dotWidth: 10,
                    spacing: 5,
                    radius: 15,
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      print(isLast);
                      submit();
                    } else {
                      //  print(isLast);
                      pageController.nextPage(
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeIn);
                    }
                  },
                  child: Icon(Icons.arrow_forward_ios_outlined),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Column buildPageViewContent(PageModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Image.asset(model.img)),
        SizedBox(
          height: 70,
        ),
        Text(
          model.title,
          style: Theme.of(context).textTheme.headline5,
        ),
        SizedBox(
          height: 35,
        ),
        Text(
          model.body,
          style: TextStyle(
            fontSize: 16,
          ),
        )
      ],
    );
  }
}
