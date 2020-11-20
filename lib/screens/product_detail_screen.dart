import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myshop/providers/product_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final String id;

  const ProductDetailScreen({this.id});

  @override
  Widget build(BuildContext context) {
    final loadedProduct =
        Provider.of<ProductProvider>(context, listen: false).findById(id);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).accentColor),
              onPressed: () => Navigator.of(context).pop(),
            ),
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                padding: EdgeInsets.symmetric(vertical: 1.5),
                width: double.infinity,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                child: Text(loadedProduct.title,textAlign: TextAlign.left,),
              ),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                '${loadedProduct.price}\$',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Text(
                  '${loadedProduct.description}',
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 800,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
