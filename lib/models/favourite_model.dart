class FavouriteModel {
  bool status;
  String message;
  FavouriteModel({required this.status, required this.message});
  factory FavouriteModel.fromJson(dynamic jsonData) {
    final status = jsonData['status'];
    final message = jsonData['message'];
    return FavouriteModel(status: status, message: message);
  }
}
