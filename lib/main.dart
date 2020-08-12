import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/cart_provider.dart';
import 'package:shop_app/src/providers/orders_provider.dart';
import 'package:shop_app/src/providers/products_provider.dart';
import 'package:shop_app/src/screens/cart_screen/cart_screen.dart';
import 'package:shop_app/src/screens/orders_screen/orders_screen.dart';
import 'package:shop_app/src/screens/product_detail_screen/product_detail_screen.dart';

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
        ChangeNotifierProvider(
          create: (ctx) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrdersProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          accentColor: Colors.deepOrangeAccent,
          fontFamily: 'Lato',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/product-detail-screen': (ctx) => ProductDetailScreen(),
          '/products-overview-screen': (ctx) => ProductsOverviewScreen(),
          '/cart-screen': (ctx) => CartScreen(),
          '/orders-screen': (ctx) => OrdersScreen(),
        },
        initialRoute: '/products-overview-screen',
      ),
    );
  }
}
