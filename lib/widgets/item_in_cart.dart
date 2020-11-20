import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myshop/providers/cart.dart';
import 'package:myshop/widgets/toast.dart';

class ItemInCart extends StatelessWidget {
  final String title;
  final String id;
  final String productId;
  final int quantity;
  final double price;

  const ItemInCart(
      {this.productId, this.title, this.id, this.quantity, this.price});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return buildShowDialog(context);
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      key: ValueKey(id),
      background: Container(
        color: Theme
            .of(context)
            .errorColor,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(10),
      ),
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Text('${price.toStringAsFixed(2)} \$'),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total: ${(price * quantity).toStringAsFixed(2)}\$'),
          trailing: Text('${quantity}x'),
        ),
      ),
    );
  }
}
