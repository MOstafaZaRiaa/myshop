import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myshop/widgets/toast.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/orders.dart';
import 'package:myshop/widgets/item_in_cart.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isEmpty = false;
  @override
  void initState() {
    final cart = Provider.of<Cart>(context, listen: false);

    if (cart.items.length == 0) {
      setState(() {
        _isEmpty = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body:_isEmpty? Column(children: [
        Expanded(
          child: Image.asset(
            'assets/photos/emptyCart.gif',
            fit: BoxFit.cover,
          ),
        ),
      ],)
      :
      Column(
        children: [
          Expanded(
            child: Card(
                    elevation: 3,
                    margin: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: cart.itemsCount,
                      itemBuilder: (context, index) => ItemInCart(
                        id: cart.items.values.toList()[index].id,
                        quantity: cart.items.values.toList()[index].quantity,
                        title: cart.items.values.toList()[index].title,
                        price: cart.items.values.toList()[index].price,
                        productId: cart.items.keys.toList()[index],
                      ),
                    ),
                  ),
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '${cart.totalAmount.toStringAsFixed(2)} \$',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading= false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed:(widget.cart.isCartEmpty() || isLoading)?null : () async{
        setState(() {
          isLoading= true;
        });
          await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.totalAmount,
            widget.cart.items.values.toList(),
          );
          setState(() {
            isLoading=false;
          });
          widget.cart.clearCart();
          buildShowToast(context, 'Your order is placed.');

      },
      child:isLoading? CircularProgressIndicator() : Text(
        'ORDER NOW',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
// Material(
// color: Theme.of(context).primaryColor,
// textStyle: TextStyle(color: Colors.white),
// borderRadius: BorderRadius.circular(30.0),
// elevation: 5.0,
// child: MaterialButton(
// onPressed: () {},
// minWidth: 400,
// height: 42.0,
// child: Text(
// 'ORDER NOW',
// style: TextStyle(
// color: Theme.of(context).primaryTextTheme.title.color),
// ),
// ),
// ),

// Navigator.push(context, MaterialPageRoute(builder: (
// context) => OrderScreen(),),);
