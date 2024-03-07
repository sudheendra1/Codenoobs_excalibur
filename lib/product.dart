class Product {
  final String barcodeNumber;
  final String title;

  Product({required this.barcodeNumber, required this.title});

  factory Product.fromJson(Map<String, dynamic> json) {
    String fullTitle = json['title'];
    List<String> titleWords = fullTitle.split(' ');
    String shortTitle = titleWords.length > 2 ? titleWords.sublist(0, 2).join(' ') : fullTitle;
    print(shortTitle);

    return Product(
      barcodeNumber: json['barcode_number'],
      title: shortTitle,

    );
  }
}