import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello, Renan'),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  Navigator.of(context).pop();
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            ],
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed('/products-overview-screen'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('Orders'),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed('/orders-screen'),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed('/user-products-screen'),
          ),
        ],
      ),
    );
  }
}
