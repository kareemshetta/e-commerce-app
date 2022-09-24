class CategoriesModel {
  bool status;
  CategoriesModelData data;
  CategoriesModel({required this.status, required this.data});
  factory CategoriesModel.fromJson(dynamic jsonData) {
    final status = jsonData['status'];
    final data = jsonData['data'];
    return CategoriesModel(
        status: status, data: CategoriesModelData.fromJson(data));
  }
}

class CategoriesModelData {
  int currentPage;
  List<Category> categories = [];
  CategoriesModelData({required this.categories, required this.currentPage});
  factory CategoriesModelData.fromJson(dynamic jsonData) {
    final currentPage = jsonData['current_page'];
    final cat = (jsonData['data'] as List).map((element) {
      return Category.fromJson(element);
    }).toList();
    return CategoriesModelData(categories: cat, currentPage: currentPage);
  }
}

class Category {
  int id;
  String name;
  String image;
  Category({required this.name, required this.id, required this.image});
  factory Category.fromJson(dynamic jsonData) {
    final id = jsonData['id'];
    final name = jsonData['name'];
    final image = jsonData['image'];
    return Category(name: name, id: id, image: image);
  }
}
