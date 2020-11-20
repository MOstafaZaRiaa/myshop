import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:myshop/models/http_exception.dart';
import 'package:myshop/providers/product.dart';

class ProductProvider extends ChangeNotifier {
  final String authToken;
  final String userId;
  ProductProvider(this.authToken,this.userId,this._items,);
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/d/da/Trousers-colourisolated.jpg/1200px-Trousers-colourisolated.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://images-na.ssl-images-amazon.com/images/I/61HZI7AqOqL._AC_SL1500_.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://www.ikea.com/gb/en/images/products/kavalkad-frying-pan-black__0241981_PE381624_S5.JPG',
    // ),
  ];

  List<Product> get items {
    return _items;
  }

  List<Product> get showFavouriteItem {
    notifyListeners();
    return _items.where((prod) => prod.isFavourite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser= false]) async {
    var filerString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://my-shop-59465.firebaseio.com/products.json?auth=$authToken&$filerString';
    try {
      final response = await http.get(url);
      final _extractData = json.decode(response.body) as Map<String, dynamic>;
      if(_extractData==null){
        return;
      }
      url = 'https://my-shop-59465.firebaseio.com/userFavourites/$userId.json?auth=$authToken';
      final favouriteResponse =await http.get(url);
      final favouriteData = json.decode(favouriteResponse.body);
      List<Product> _loadedProducts = [];
      _extractData.forEach((prodId, prodData) {
        _loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
          isFavourite: favouriteData ==null? false : favouriteData[prodId] ??false,
        ),);
      });
      _items = _loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = 'https://my-shop-59465.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId':userId,
        }),
      );
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        imageUrl: product.imageUrl,
        price: product.price,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String productId, Product newProduct) async{
    final product = _items.indexWhere((prod) => prod.id == productId);
     var url = 'https://my-shop-59465.firebaseio.com/products/$productId.json?auth=$authToken';
     await http.patch(url,body:json.encode({
       'title': newProduct.title,
       'description': newProduct.description,
       'imageUrl': newProduct.imageUrl,
       'price': newProduct.price,
     }),);
    _items[product] = newProduct;
    notifyListeners();
  }

  Future<void> updateFavouriteStatus(String productId,bool isFavourite)async{
    var url = 'https://my-shop-59465.firebaseio.com/userFavourites/$userId/$productId.json?auth=$authToken';
    final oldStatus= isFavourite;
    try{
      await http.put(
        url,
        body:json.encode(
        isFavourite,
      ),);
    }catch(error){
      isFavourite=oldStatus;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId)async{
    var url = 'https://my-shop-59465.firebaseio.com/products/$productId.json?auth=$authToken';
    final _existingProductIndex = _items.indexWhere((prod) => prod.id==productId);
    var _existingProduct = _items[_existingProductIndex];

    _items.removeAt(_existingProductIndex);
    notifyListeners();

   final response = await http.delete(url);
        if(response.statusCode>=400){
          _items.insert(_existingProductIndex, _existingProduct);
          notifyListeners();
          throw HttpException(message: 'Could not delete product.');
        }
      _existingProduct = null;
  }
}
