import 'package:flutter/material.dart';

import 'package:myshop/providers/orders.dart';
import 'package:myshop/providers/product_provider.dart';
import 'package:myshop/screens/product_overview_screen.dart';
import 'package:myshop/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'providers/auth.dart';
import 'providers/cart.dart';
import 'screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, ProductProvider>(
            //create: (BuildContext context) => ProductProvider(),
            update: (BuildContext context, value,
                    ProductProvider previousProducts) =>
                ProductProvider(value.token, value.userId,
                    previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (context, auth, previousProducts) => Orders(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.orders),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => Cart(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, child) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primaryColor: Color(0xFF003049),
              accentColor: Color(0xFFd62828),
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (ctx, authResultSnapShot) =>
                        authResultSnapShot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ), //ProductOverviewScreen(),
          ),
        ));
  }
}
