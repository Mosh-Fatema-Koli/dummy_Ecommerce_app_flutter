
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Cart/page/cart_page.dart';
import '../cubit/product_cubit.dart';
import '../cubit/product_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BlocProvider(
        create: (_) => ProductCubit()..loadData(),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Products'),
            actions: [
              BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  int count = 0;
                  if (state is ProductLoadedState) {
                    count = state.cartItems.length;
                  }

                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                          onPressed: () {
                            // Navigate to CartPage
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CartPage()),
                            );

                        },
                      ),
                      if (count > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        )
                    ],
                  );
                },
              )
            ],

          ),
          body: BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              // Loading indicator while initial state
              if (state is ProductInitial) {
                return const Center(child: CircularProgressIndicator());
              }

              // Error state
              if (state is ProductErrorState) {
                return Center(child: Text(state.message));
              }

              // Loaded state
              if (state is ProductLoadedState) {
                final products = state.listOfData;

                if (products.isEmpty) {
                  return const Center(child: Text("No products available"));
                }
                // Responsive columns based on screen width
                final crossAxisCount = (MediaQuery.of(context).size.width / 200).floor();
                return RefreshIndicator(
                  onRefresh: () async => context.read<ProductCubit>().loadData(),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount > 1 ? crossAxisCount : 2,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                  child: Image.network(
                                    product.thumbnail,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                    const Center(child: Icon(Icons.error)),
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(child: CircularProgressIndicator());
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '\$${product.price}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Add product to cart
                                    context.read<ProductCubit>().addToCart(product);

                                    // Optional: show feedback
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${product.title} added to cart'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add_shopping_cart),
                                  label: const Text('Add to Cart'),
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(36),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        );
                      }

                  ),
                );
              }

              // Fallback empty state
              return const Center(child: Text("No products available"));
            },
          ),
        ),
      ),
    );
  }
}
