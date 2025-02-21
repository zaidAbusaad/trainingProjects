import 'package:ecommerceapp/components/item_card.dart';
import 'package:ecommerceapp/list_cubit/product_cubit.dart';
import 'package:ecommerceapp/list_cubit/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

    class FavouriteItemsScreen extends StatelessWidget {
      const FavouriteItemsScreen({super.key});

      @override
      Widget build(BuildContext context) {
        ProductCubit cubit= ProductCubit.get(context);
        return    BlocBuilder<ProductCubit,ProductStates>(
          builder: (context,state) {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: cubit.items.where((element) => element.isFavorite == true,).toList().length,
              itemBuilder: (context, index) {
                return ItemCard(items:cubit.items.where((element) => element.isFavorite == true,).toList()[index] );
              },
            );
          }
        );
      }
    }
