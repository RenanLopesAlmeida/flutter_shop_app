import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/auth_provider.dart';
import 'package:shop_app/src/providers/cart_provider.dart';
import 'package:shop_app/src/providers/orders_provider.dart';
import 'package:shop_app/src/providers/products_provider.dart';
import 'package:shop_app/src/screens/auth_screen/auth_screen.dart';
import 'package:shop_app/src/screens/cart_screen/cart_screen.dart';
import 'package:shop_app/src/screens/edit_product_screen/edit_product_screen.dart';
import 'package:shop_app/src/screens/orders_screen/orders_screen.dart';
import 'package:shop_app/src/screens/product_detail_screen/product_detail_screen.dart';
import 'package:shop_app/src/screens/user_products_screen/user_products_screen.dart';

import 'src/screens/products_overview_screen/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          //ChangeNotifierProvider(create: (ctx) => ProductsProvider(null, [])),
          ChangeNotifierProvider(create: (ctx) => AuthProvider()),
          ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
            create: (context) => ProductsProvider(null, null, []),
            update: (context, auth, previousProducts) {
              return ProductsProvider(auth.token, auth.userId,
                  (previousProducts == null) ? [] : previousProducts.products);
            },
          ),
          ChangeNotifierProvider(create: (ctx) => CartProvider()),
          ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
            create: (context) => OrdersProvider(null, []),
            update: (context, auth, previousOrder) {
              return OrdersProvider(auth.token,
                  previousOrder == null ? [] : previousOrder.orders);
            },
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.deepPurple,
                accentColor: Colors.deepOrangeAccent,
                fontFamily: 'Lato',
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              routes: {
                '/auth-screen': (ctx) => AuthScreen(),
                '/product-detail-screen': (ctx) => ProductDetailScreen(),
                '/products-overview-screen': (ctx) => ProductsOverviewScreen(),
                '/cart-screen': (ctx) => CartScreen(),
                '/orders-screen': (ctx) => OrdersScreen(),
                '/user-products-screen': (ctx) => UserProductsScreen(),
                '/edit-product-screen': (ctx) => EditProductScreen(),
              },
              home: (auth.isAuth) ? ProductsOverviewScreen() : AuthScreen(),
            );
          },
        ));
  }
}
