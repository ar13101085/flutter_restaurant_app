import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_user_demo/Service/FirebaseLogin.dart';
import 'package:restaurant_user_demo/db/UserSharePref.dart';
import 'package:restaurant_user_demo/pages/my_home_page.dart';
import 'package:restaurant_user_demo/provider/cart_list_provider.dart';

void main() => runApp(MyApp());


class LoginPage extends StatelessWidget{
  String email;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                //controller: TextEditingController(text: "Hello"),
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    //labelText: 'Address',
                    hintText: "Email Address"
                ),
                onChanged: (value){
                  email=value;
                },
              ),
              GestureDetector(
                onTap: (){
                  //FirebaseCart.cart(, deliveryLocation, maps)
                  print(email);
                  FirebaseLogin().loginUser(email).then((result){
                    result.documents.forEach((item){
                      FirebaseLogin().saveUserInfo(item);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>MyHomePage(title: "User Home",)),
                      );
                    });
                  });
                },
                child: Card(child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(child: Text("Login"))
                    )
                )),
              )
            ],
          ),
        ),
      ),
    );
  }

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return ChangeNotifierProvider(
      create: (context){
        return new CartProvider();
      },
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder<Map>(
            future: UserSharePref().getUserInfo(),
            builder: (context,response){
              if(response.connectionState==ConnectionState.waiting){
                return Text("Loading....");
              }
              else if(response.data==null || response.data.keys==0){
                return LoginPage();
              }else{
                return MyHomePage( title: "User App");

              }
            }
        ),
      ),

    );
  }
}


