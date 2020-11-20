import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:myshop/providers/orders.dart';
import 'package:myshop/widgets/orderd_item.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isEmpty = false;
  bool _isLoading = false;
  @override
  void initState(){
    setState(() {
      _isLoading = true;
    });
     Provider.of<Orders>(context,listen: false).fetchOrders().then((value){
       setState(() {
         _isLoading = false;
       });
       if (Provider.of<Orders>(context, listen: false).orders.length == 0) {
         setState(() {
           _isEmpty = true;
         });
       }
     });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Orders',
        ),
      ),
      body:_isLoading? Center(child: CircularProgressIndicator()): _isEmpty
          ? Column(
        children: [
          Expanded(
            child: Image.asset(
              'assets/photos/emptyOrders.gif',
              fit: BoxFit.cover,
            ),
          ),
        ],
      )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (BuildContext context, int index) => OrderedItem(
                order: orderData.orders[index],
              ),
            ),
    );
  }
}
