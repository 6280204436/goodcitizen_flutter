class CommonItemModel {
  dynamic id;
  String? title;
  String? value;
  String? imagePath;
  String? secondImage;
  String? secondValue;
  bool isSelected = false;

  CommonItemModel(
      {this.id,
      this.title,
      this.value,
      this.imagePath,
      this.secondValue,
      this.secondImage});
}
