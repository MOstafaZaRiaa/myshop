import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myshop/providers/product_provider.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/screens/drawer_screen.dart';
import 'package:myshop/widgets/badge.dart';
import 'package:myshop/widgets/products_grid.dart';

enum FilterOption {
  Favourite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showFavourite = false;
  bool isLoading = false;

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<ProductProvider>(context,listen: false).fetchAndSetProducts();
  } 
  
  @override
  void initState() {

    setState(() {
      isLoading=true;
    });
    Provider.of<ProductProvider>(context,listen: false).fetchAndSetProducts().then((value){
      setState(() {
        isLoading=false;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: DrawerScreen(),
        appBar: AppBar(
          title: Text('MyShop'),
          actions: <Widget>[
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Favourite'),
                  value: FilterOption.Favourite,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOption.All,
                ),
              ],
              onSelected: (FilterOption selectedItem) {
                setState(() {
                  if (selectedItem == FilterOption.Favourite) {
                    showFavourite = true;
                  } else {
                    showFavourite = false;
                  }
                });
              },
            ),
            Consumer<Cart>(
              builder: (BuildContext context, cart, Widget child) => Badge(
                child: child,
                value: cart.itemsCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(),
                    ),
                  );
                },
              ),
            )
          ],
        ),
        body: isLoading? Center(child: CircularProgressIndicator(),) : RefreshIndicator(
          onRefresh: ()=>_refreshProducts(context),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: ProductsGrid(showFavourite: showFavourite),
          ),
        ),
      ),
    );
  }
}
