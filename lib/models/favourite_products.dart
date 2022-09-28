class FavouriteProductsModel {
  bool status;
  FavouriteProductsData data;
  FavouriteProductsModel({required this.status, required this.data});

  factory FavouriteProductsModel.fromJson(dynamic jsonData) {
    final status = jsonData['status'];
    final data = FavouriteProductsData.fromJson(jsonData['data']);
    return FavouriteProductsModel(status: status, data: data);
  }
}

class FavouriteProductsData {
  int currentPage;
  List<FavouriteProduct> favouriteProducts = [];
  FavouriteProductsData(
      {required this.currentPage, required this.favouriteProducts});

  factory FavouriteProductsData.fromJson(dynamic jsonData) {
    final currentPage = jsonData['current_page'];
    final favouriteProducts = (jsonData['data'] as List).map((element) {
      return FavouriteProduct.fromJson(element['product']);
    }).toList();
    return FavouriteProductsData(
        currentPage: currentPage, favouriteProducts: favouriteProducts);
  }
}

class FavouriteProduct {
  int id;
  dynamic price;
  dynamic oldPrice;
  int discount;
  String image;
  String name;
  String description;
  FavouriteProduct(
      {required this.id,
      required this.name,
      required this.image,
      required this.discount,
      required this.oldPrice,
      required this.price,
      required this.description});

  factory FavouriteProduct.fromJson(dynamic jsonData) {
    print(jsonData['id']);
    print(jsonData['price']);
    print('img fav: ${jsonData['image']}');
    print('desc fav: ${jsonData['description']}');
    print('name fav: ${jsonData['name']}');

    final id = jsonData['id'];
    final price = jsonData['price'];
    final oldPrice = jsonData['old_price'];
    final discount = jsonData['discount'];
    final image = jsonData['image'];
    final name = jsonData['name'];
    final description = jsonData['description'];

    return FavouriteProduct(
        id: id,
        name: name,
        image: image,
        discount: discount,
        oldPrice: oldPrice,
        price: price,
        description: description);
  }
}
