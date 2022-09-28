class SearchModel {
  final bool status;
  dynamic message;
  SearchModelData searchModelData;
  SearchModel(
      {required this.status,
      required this.message,
      required this.searchModelData});

  factory SearchModel.fromJson(dynamic jsonData) {
    final status = jsonData['status'];
    final message = jsonData['message'];
    final data = SearchModelData.fromJson(jsonData['data']);
    return SearchModel(status: status, message: message, searchModelData: data);
  }
}

class SearchModelData {
  final int currentPage;
  List<FoundedProduct> foundedProduct;
  SearchModelData({required this.currentPage, required this.foundedProduct});
  factory SearchModelData.fromJson(dynamic jsonData) {
    final currentPage = jsonData['current_page'];
    final data = jsonData['data'];
    final foundedProduct = (data as List)
        .map((element) => FoundedProduct.fromJson(element))
        .toList();
    return SearchModelData(
        currentPage: currentPage, foundedProduct: foundedProduct);
  }
}

class FoundedProduct {
  final int id;
  dynamic price;
  final String image;
  final String name;
  final String description;
  dynamic isFavourite;
  FoundedProduct(
      {required this.id,
      required this.name,
      required this.price,
      required this.image,
      required this.isFavourite,
      required this.description});

  factory FoundedProduct.fromJson(dynamic jsonData) {
    final id = jsonData['id'];
    final name = jsonData['name'];
    final price = jsonData['price'];
    final image = jsonData['image'];
    final description = jsonData['description'];
    final isFavourite = jsonData['in_favorites'];
    return FoundedProduct(
        id: id,
        name: name,
        price: price,
        image: image,
        isFavourite: isFavourite,
        description: description);
  }
}
