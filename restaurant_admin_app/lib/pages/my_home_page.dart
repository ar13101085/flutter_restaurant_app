import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_user_demo/model/cart.dart';
import 'package:restaurant_user_demo/model/product.dart';
import 'package:restaurant_user_demo/pages/cart_list.dart';
import 'package:restaurant_user_demo/pages/order_history_page.dart';
import 'package:restaurant_user_demo/pages/user_setting.dart';
import 'package:restaurant_user_demo/provider/cart_list_provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    var provider=Provider.of<CartProvider>(context);
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Order History'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>OrderHistoryPage()),
                  );
                },
              ),
              ListTile(
                title: Text('Setting'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>UserSetting()),
                  );
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          actions: <Widget>[
            GestureDetector(
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Icon(Icons.shopping_cart),

                  ),

                  Positioned(
                      right: 2,
                      top: 2,
                      child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: Text(
                              provider.totalItem().toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                      )
                  )
                ],
              ),
              onTap: ()=>{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>CartList()),
                )
              },
            )
          ],
        ),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('/restaurants/res-1/products')
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return new Text('Loading...');
                default:
                  return new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return Container(
                        padding: EdgeInsets.all(7),
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Text(
                                document.data["name"],
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),
                              ),
                              FadeInImage.assetNetwork(
                                placeholder: 'assets/empty_image.png',
                                image: document.data["pic"],
                              ),
                              GestureDetector(
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  child:  Center(child: Icon(Icons.add_shopping_cart,size: 40,color: Colors.green,)),
                                ),
                                onTap: (){
                                  Product product=Product(document.documentID,document.data["name"],document.data["price"],document.data["pic"]);
                                  Cart cart=Cart(product.productId,1,product);
                                  provider.addItem(cart);
                                },
                              )

                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
              }
            },

          ),
        )
    );
  }
}