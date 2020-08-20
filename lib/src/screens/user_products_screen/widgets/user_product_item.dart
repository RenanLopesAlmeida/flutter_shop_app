import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final Function deleteProduct;

  UserProductItem({this.id, this.title, this.imageUrl, this.deleteProduct});

  @override
  Widget build(BuildContext context) {
    final _scaffold = Scaffold.of(context);

    return Container(
      height: 90,
      child: Card(
        elevation: 10,
        child: Center(
          child: ListTile(
            leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
            title: Text(title),
            trailing: Container(
              width: 100,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/edit-product-screen',
                        arguments: id,
                      );
                    },
                    color: Theme.of(context).primaryColor,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      try {
                        await this.deleteProduct(id);
                      } catch (error) {
                        _scaffold.showSnackBar(SnackBar(
                          content: Text('Deleting failed!'),
                        ));
                      }
                    },
                    color: Theme.of(context).errorColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
