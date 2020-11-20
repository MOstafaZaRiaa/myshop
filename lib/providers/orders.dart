import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:myshop/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;


  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime,});
}

class Orders extends ChangeNotifier {
  final String authToken;
  final String userId;
  Orders(this.authToken,this.userId,this._orders);

  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return _orders;
  }

/*
هذه الدالة لتخزين طلبات المستخدم في صفحة الطلبات و علي سيرفر الفايربيز
 */
  Future<void> addOrder(double total, List<CartItem> cartProduct) async {
    final url = 'https://my-shop-59465.firebaseio.com/orders/$userId.json?auth=$authToken';
    var timeNow = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timeNow.toIso8601String(),
        'products': cartProduct
            .map((prod) => {
                  'id': prod.id,
                  'title': prod.title,
                  'quantity': prod.quantity,
                  'price': prod.price,
                })
            .toList(),
      }),
    );
      _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProduct,
        dateTime: timeNow,
      ),
    );
    notifyListeners();
  }

  /*
هذه الدالة لتحميل طلبات المستخدم من علي سيرفر الفايربيز
 */
  Future<void> fetchOrders() async {
    final url = 'https://my-shop-59465.firebaseio.com/orders/$userId.json?auth=$authToken';
    List<OrderItem> loadedOrders = [];
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if(extractedData==null){
      _orders=[];
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (products) => CartItem(
                  id: products['id'],
                  title: products['title'],
                  quantity: products['quantity'],
                  price: products['price'],
                ),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders;
    notifyListeners();
  }
}