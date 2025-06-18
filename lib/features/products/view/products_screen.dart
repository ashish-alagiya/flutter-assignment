import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:product_demo/features/products/model/product_model.dart';
import 'package:product_demo/features/products/viewmodel/product_bloc.dart';
import 'package:product_demo/features/products/viewmodel/product_event.dart';
import 'package:product_demo/features/products/viewmodel/product_state.dart';
import 'package:product_demo/features/products/widgets/product_card.dart';
import 'package:product_demo/utils/app_strings.dart';
import 'package:product_demo/utils/color_constant.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final List<String> categories = [
    AppString.all,
    AppString.electronics,
    AppString.jewelery,
    AppString.mensclothing,
    AppString.womensclothing
  ];

  String selectedCategory = AppString.all;

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 50,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppString.products,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: SizedBox(
              height: 50.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: ChoiceChip(
                      label: Text(category.toUpperCase()),
                      selected: selectedCategory == category,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedCategory = category;
                          });
                          if (category == AppString.all) {
                            context.read<ProductBloc>().add(LoadProducts());
                          } else {
                            context.read<ProductBloc>().add(
                                  LoadProductsByCategory(category),
                                );
                          }
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProductLoaded) {
                  return _buildProductGrid(state.products);
                } else if (state is ProductError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Error: ${state.message}',
                          style: TextStyle(fontSize: 16.sp),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            if (selectedCategory == AppString.all) {
                              context.read<ProductBloc>().add(LoadProducts());
                            } else {
                              context.read<ProductBloc>().add(
                                    LoadProductsByCategory(selectedCategory),
                                  );
                            }
                          },
                          child: const Text(AppString.retry),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}
