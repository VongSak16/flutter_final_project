class Product {
  final int id;
  final String title;
  final String category;
  final String description;
  final String image;
  final double price;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.image,
    required this.price,
  });

  Product.placeholder()
      : id = 0,
        title = 'N/A',
        category = 'N/A',
        description = 'N/A',
        image = 'https://via.placeholder.com/150',
        price = 0.0;
}
