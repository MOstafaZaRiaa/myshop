import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:myshop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiredDate;
  String _userId;
  Timer _authTimer;
  String userEmail;

  bool get isAuth {
    return token != null;
  }
  String get userId {
    return _userId;
  }

  String get token {
    if (_token != null &&
        _expiredDate != null &&
        _expiredDate.isAfter(
          DateTime.now(),
        )) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegman) async {
    try {
      var url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegman?key=AIzaSyBrkqfd-ISl6C_vUnzvkP6_sdV4OedGvLI ';
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print(responseData['error']['message']);
        throw HttpException(message: responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiredDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      //_autoLogout();
      if(token != null){
        userEmail = email;
      }else{
        userEmail=' ';
      }
      notifyListeners();
      final prefs =await SharedPreferences.getInstance();
      final userData = json.encode({
        'token':_token,
        'userId':_userId,
        'expiredDate':_expiredDate.toIso8601String(),
        'email':email,
      });
      prefs.setString('userData',userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> autoLogin()async{
    final prefs=await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String,Object>;
    final expireDate = DateTime.parse(extractedUserData['expiredDate']);
    if(expireDate.isBefore(DateTime.now())){
      return false;
    }
    _token=extractedUserData['token'];
    _userId=extractedUserData['userId'];
    _expiredDate=expireDate;
    userEmail=extractedUserData['email'];
    notifyListeners();
    //_autoLogout();
    return true;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logOut()async{
    _userId=null;
    _expiredDate=null;
    _token=null;
    userEmail=null;
    if(_authTimer !=null){
      _authTimer.cancel();
      _authTimer=null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  // void _autoLogout(){
  //   if(_authTimer !=null){
  //     _authTimer.cancel();
  //   }
  //   final timeToExpire = _expiredDate.difference(DateTime.now()).inSeconds;
  //   _authTimer = Timer(Duration(seconds: timeToExpire), logOut);
  // }
}
