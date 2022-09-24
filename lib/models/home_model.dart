class HomeModel {
  bool status;
  HomeDataModel homeDataModel;
  HomeModel({required this.status, required this.homeDataModel});

  factory HomeModel.fromJson(dynamic jsonData) {
    final status = jsonData['status'];
    print('statusssssss:$status');
    final homeDtaModel = HomeDataModel.fromJson(jsonData['data']);
    return HomeModel(status: status, homeDataModel: homeDtaModel);
  }
}

class HomeDataModel {
  List<BannerModel> banners = [];
  List<ProductModel> products = [];

  HomeDataModel({required this.products, required this.banners});

  HomeDataModel.fromJson(dynamic jsonData) {
    banners = (jsonData['banners'] as List).map((element) {
      return BannerModel.fromJson(element);
    }).toList();

    products = (jsonData['products'] as List).map((element) {
      return ProductModel.fromJson(element);
    }).toList();
  }
}

class BannerModel {
  int id;
  String img;
  BannerModel({required this.id, required this.img});
  factory BannerModel.fromJson(dynamic data) {
    final id = data['id'];
    final img = data['image'];
    return BannerModel(id: id, img: img);
  }
}

class ProductModel {
  int id;
  String img;
  dynamic price;
  String name;
  dynamic discount;
  dynamic oldPrice;
  bool inCart;
  bool inFavourite;

  ProductModel(
      {required this.id,
      required this.img,
      required this.name,
      required this.discount,
      required this.price,
      required this.oldPrice,
      required this.inCart,
      required this.inFavourite});

  factory ProductModel.fromJson(dynamic jsonData) {
    final id = jsonData['id'];
    final img = jsonData['image'];
    final name = jsonData['name'];
    final discount = jsonData['discount'];
    final price = jsonData['price'];
    final oldPrice = jsonData['old_price'];
    final inCart = jsonData['in_cart'];
    print('incart:${jsonData['in_cart']}');
    final inFavourite = jsonData['in_favorites'];
    print('in favourite${jsonData['in_favorites']}');
    return ProductModel(
        id: id,
        img: img,
        name: name,
        discount: discount,
        price: price,
        oldPrice: oldPrice,
        inCart: inCart,
        inFavourite: inFavourite);
  }
}
