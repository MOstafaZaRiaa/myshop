import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myshop/providers/product_provider.dart';
import 'package:myshop/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String id;
  final String imageUrl;

  const UserProductItem({this.id, this.title, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    var snackBar = Scaffold.of(context);
    final productData = Provider.of<ProductProvider>(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProductScreen(
                        id: id,
                      ),
                    ),
                  );
                }),
            IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                onPressed: () async {
                  try {
                    await productData.deleteProduct(id);
                    snackBar.showSnackBar(
                      SnackBar(
                        content: Text('Deleted.'),
                      ),
                    );
                  } catch (error) {
                    snackBar.showSnackBar(
                      SnackBar(content: Text('Deleting failed.')),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
