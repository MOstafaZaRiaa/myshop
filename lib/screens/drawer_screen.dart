import 'package:flutter/material.dart';
import 'package:myshop/providers/auth.dart';

import 'package:myshop/screens/order_screen.dart';
import 'package:myshop/screens/product_overview_screen.dart';
import 'package:myshop/screens/user_product_screen.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userEmail = Provider.of<Auth>(context,listen: false).userEmail;
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend!'),

            automaticallyImplyLeading: false,

          ),
          Container(
            padding:EdgeInsets.only(left: 15),
            color: Theme.of(context).primaryColor,
            width: double.infinity,
            height: 30,
            alignment: Alignment.topLeft,
            child: Text(userEmail,style: TextStyle(color: Colors.white,),),

          ),
          ListTile(
            onTap: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductOverviewScreen(),
                ),
              );

            },
            leading: Icon(Icons.shop),

            title: Text('Main Page',style: TextStyle(fontSize: 16),),
          ),
          Divider(),
          ListTile(
            onTap: (){
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OrderScreen(),
              ),
            );
              },
            leading: Icon(Icons.payment),
            title: Text('Orders',style: TextStyle(fontSize: 16),),
          ),
          Divider(),
          ListTile(
            onTap: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProductScreen(),
                ),
              );
            },
            leading: Icon(Icons.edit),
            title: Text('Manage Products',style: TextStyle(fontSize: 16),),
          ),
          Spacer(),
          Divider(),
          ListTile(
            onTap: (){
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
              Provider.of<Auth>(context,listen: false).logOut();
            },
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign out',style: TextStyle(fontSize: 16),),
          ),
        ],
      ),
    );
  }
}
