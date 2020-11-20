import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myshop/screens/drawer_screen.dart';
import 'package:myshop/widgets/user_product_item.dart';
import 'package:myshop/providers/product_provider.dart';
import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context,listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    print('building');
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(

        drawer: DrawerScreen(),
        appBar: AppBar(
          title: Text('Your Products'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => EditProductScreen(),
                    ),
                  );
                }),
          ],
        ),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => _refreshProducts(context),
                      child: Consumer<ProductProvider>(
                        builder: ( context, productData, child)=> Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (ctx, index) => Column(
                              children: [
                                UserProductItem(
                                  title: productData.items[index].title,
                                  id: productData.items[index].id,
                                  imageUrl: productData.items[index].imageUrl,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
        ),
      ),
    );

  }
}
