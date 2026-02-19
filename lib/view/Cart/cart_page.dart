import 'package:boilerplate_of_cubit/view/Home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cart_cubit.dart';
import 'cubit/cart_state.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BlocProvider(
        create: (_) => CartCubit(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: () {
              // Navigate to CartPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomePage()),
              );
            }, icon: Icon(Icons.arrow_back_ios_new)),
            title: const Text('My Cart'),
          ),
          body: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state is CartLoadedState) {
                final cartItems = state.cartItems;

                if (cartItems.isEmpty) {
                  return const Center(
                    child: Text(
                      "Your cart is empty",
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                // Total price considering quantity
                double totalPrice = cartItems.fold(
                    0, (sum, item) => sum + item.price * item.quantity);

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final product = cartItems[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.thumbnail,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                                ),
                              ),
                              title: Text(
                                product.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                  '\$${product.price.toStringAsFixed(2)} x ${product.quantity}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Subtract button
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    onPressed: () {
                                      context
                                          .read<CartCubit>()
                                          .subtractFromCart(product);
                                    },
                                  ),
                                  Text('${product.quantity}'),
                                  // Add button
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    onPressed: () {
                                      context
                                          .read<CartCubit>()
                                          .addToCart(product);
                                    },
                                  ),
                                  // Delete button
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      context
                                          .read<CartCubit>()
                                          .removeFromCart(product);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.grey.shade200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total: \$${totalPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Proceed to checkout
                            },
                            child: const Text('Checkout'),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }

              if (state is CartErrorState) {
                return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ));
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
