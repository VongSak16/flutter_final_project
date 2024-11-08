import 'package:flutter/material.dart';
import 'package:flutter_final_project/cart_provider.dart';
import 'package:flutter_final_project/main.dart';
import 'package:provider/provider.dart';

import 'cart_item.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Your Cart", style: TextStyle(color: Colors.white),),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          final cartItems = cart.items.values.toList();

          return cartItems.isEmpty
              ? const Center(child: Text("Your cart is empty!"))
              : ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (ctx, i) => CartItemWidget(
              cartItem: cartItems[i],
              removeItem: () {
                cart.removeOneItem(cartItems[i].product.id.toString());
              },
            ),
          );
        },
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback removeItem;

  const CartItemWidget({
    required this.cartItem,
    required this.removeItem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: Container(
            width: 60,
            height: 60,
            child: Image.network(
              baseUrl+cartItem.product.image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                );
              },
            ),
          ),
          title: Text(cartItem.product.title),
          subtitle: Text('Quantity: ${cartItem.quantity}'),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: removeItem,
          ),
        ),
      ),
    );
  }
}