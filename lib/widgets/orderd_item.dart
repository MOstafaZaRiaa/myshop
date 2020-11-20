import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:myshop/providers/orders.dart';

class OrderedItem extends StatefulWidget {
  final OrderItem order;
  OrderedItem({this.order});
  @override
  _OrderedItemState createState() => _OrderedItemState();
}

class _OrderedItemState extends State<OrderedItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:_expanded? min(widget.order.products.length * 20.0 + 120, 200) : 95,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('${widget.order.amount}\$'),
              subtitle: Text(
                DateFormat('dd/MM/yyyy  hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                height: _expanded?  min(widget.order.products.length * 23.0 +10, 150) : 0,
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                child: ListView(
                  children: widget.order.products
                      .map(
                        (prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.quantity}x \$${prod.price}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),

                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
