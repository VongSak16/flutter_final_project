import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_final_project/cart_provider.dart';
import 'package:flutter_final_project/cart_screen.dart';
import 'package:flutter_final_project/product.dart';
import 'package:flutter_final_project/product_detail_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

//const String baseUrl = 'http://127.0.0.1:5000';
const String baseUrl = 'http://192.168.100.7:5000';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color myColor = Color.fromRGBO(33, 150, 243, 1.0);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()), // Provide CartProvider
      ],
      child: MaterialApp(
        title: 'MY APP',
        theme: ThemeData(
          primaryColor: myColor,
          brightness: Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: myColor,
            brightness: Brightness.light,
            secondary: myColor,
          ),
        ),
        darkTheme: ThemeData(
          primaryColor: myColor,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: myColor,
            primary: myColor,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: const Homepages(),
      ),
    );
  }
}

class Homepages extends StatefulWidget {
  const Homepages({super.key});

  @override
  _HomepagesState createState() => _HomepagesState();
}

class _HomepagesState extends State<Homepages> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    //final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load products');
    }
  }

  int _getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 1200) {
      return 5; // Web
    } else if (screenWidth > 800) {
      return 4; // Tablet
    } else if (screenWidth > 600) {
      return 3; // Small tablet / large phone
    } else {
      return 2; // Phone
    }
  }

  double _getAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 1200) {
      return 2 / 3; // Web
    } else if (screenWidth > 800) {
      return 2 / 2.5; // Tablet
    } else {
      return 2 / 2.7; // Phone
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate values for crossAxisCount and aspectRatio before passing them
    int crossAxisCount = _getCrossAxisCount(context);
    double aspectRatio = _getAspectRatio(context);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.blue,
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text(
          "Home",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount, // Calculated value
                  childAspectRatio: aspectRatio, // Calculated value
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    name: product['title'],
                    price: double.parse(product['price'].toString()),
                    imageUrl: product['image'],
                    onTap: () {
                      // Navigate to ProductDetail and pass the product information
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            product: Product(
                              id: int.parse(product['id'].toString()),
                              title: product['title'] ?? 'N/A',
                              category: product['category'] ?? 'N/A',
                              description: product['description'] ?? 'N/A',
                              image: product['image'] ?? 'https://via.placeholder.com/150',
                              price: double.parse(product['price'].toString()),
                            ),
                          ),
                        ),
                      );
                    },
                    onFavoriteTap: () {
                      print('Favorite for ${product['title']} pressed');
                    },
                  );
                },
              ),
            ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  const ProductCard({
    Key? key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.onTap,
    required this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double borderRadius = 5;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color with opacity
            blurRadius: 10, // Softness of the shadow
            offset: Offset(0, 4), // Position of the shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: Colors.white, // Set background color for the Material widget
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderRadius),
                        topRight: Radius.circular(borderRadius),
                      ),
                      child: Image.network(
                        baseUrl + (imageUrl ?? 'https://via.placeholder.com/150'),
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        name,
                        maxLines: 2, // Limit the text to 2 lines
                        overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "\$${price.toStringAsFixed(2)}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // Handle overflow
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.grey[800],
                      size: 22,
                    ),
                    onPressed: onFavoriteTap,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
