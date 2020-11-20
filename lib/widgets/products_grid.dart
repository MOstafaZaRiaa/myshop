import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myshop/providers/product_provider.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final showFavourite;
  const ProductsGrid({this.showFavourite});

  @override
  Widget build(BuildContext context) {
    final productsData =Provider.of<ProductProvider>(context);
    final products = showFavourite ? productsData.showFavouriteItem : productsData.items;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3/2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount : products.length ,
      itemBuilder: (ctx,index) => ChangeNotifierProvider.value(
        value:  products[index],
        child: ProductItem(),
      ),
    );
  }
}
// id: products[index].id,
// imageUrl: products[index].imageUrl,
// title: products[index].title,