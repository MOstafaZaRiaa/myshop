import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({ this.id, this.title, this.quantity, this.price});
}

class Cart with ChangeNotifier {

  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return _items;
  }

  int get itemsCount{
    return _items.length;
  }

  double get totalAmount{
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total = total + cartItem.quantity *cartItem.price;
    });
    return total;
  }

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId){
    if(_items.containsKey(productId)){
      if(_items[productId].quantity > 1){
        _items.update(productId, (existingCarItem) => CartItem(
          id: existingCarItem.id,
          quantity: existingCarItem.quantity-1,
          title: existingCarItem.title,
          price: existingCarItem.price,
        ),);
      }else{
        _items.remove(productId);
      }
    }
    notifyListeners();

  }

  bool isCartEmpty(){
    return _items.isEmpty;
}
  void clearCart(){
    _items = {};
    notifyListeners();
  }
}
