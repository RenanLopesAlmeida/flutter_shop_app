import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/src/providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _productId = ModalRoute.of(context).settings.arguments as String;
    final _product = Provider.of<ProductsProvider>(context, listen: false)
        .findById(_productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_product.title),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Hero(
            tag: _productId,
            child: Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                _product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Price: ',
                style: TextStyle(color: Colors.black45, fontSize: 20),
              ),
              Text(
                '\$${_product.price}',
                style: TextStyle(color: Colors.black87, fontSize: 20),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Description',
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Text(
                  '${_product.description}',
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
