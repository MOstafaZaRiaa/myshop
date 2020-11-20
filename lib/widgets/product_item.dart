import 'package:flutter/material.dart';
import 'package:myshop/providers/product_provider.dart';
import 'package:provider/provider.dart';

import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/product.dart';
import 'package:myshop/screens/product_detail_screen.dart';


class ProductItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    /*
    * الويدجيت دي بتعمل عرض للمنتج في الصفحة الرئيسية
    * */
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(id: product.id),
              ),
            );
          },
          child: Hero(
            tag:product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/photos/imageLoading.gif'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover, 
            ),
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (BuildContext context, value, Widget child) => IconButton(
              icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () {
                product.toggleFavouriteStatus();
                Provider.of<ProductProvider>(context,listen: false).updateFavouriteStatus(product.id, product.isFavourite);
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.add_shopping_cart_outlined,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added to cart!'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(label: 'UNDO',onPressed: (){
                  cart.removeSingleItem(product.id);
                },),
              ));
            },
          ),
          backgroundColor: Colors.black45,
        ),
      ),
    );
  }
}
