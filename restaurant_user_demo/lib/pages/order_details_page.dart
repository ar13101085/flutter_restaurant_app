import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_Admin_demo/service/FirebaseOrderUpdate.dart';

class OrderDetailsPage extends StatelessWidget{
  String orderId;

  OrderDetailsPage(this.orderId);

  String getStatus(int type){
    if(type==2){
      return "On the way";
    }else if(type==3){
      return "Deliverd";
    }else{
      return "Processing";
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Order Details"),
        ),
        body: Container(
            child: StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance.document("orders/"+orderId).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Text("Loading....");
                }

                var items=snapshot.data.data["items"];
                print(items);

                return ListView.builder(itemBuilder: (context,idx){
                  int oderItemPosition=idx-1;
                  if(idx==0){
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("ID#"+orderId),
                            Text(getStatus(snapshot.data.data["status"]))
                          ],
                        ),
                      ),
                    );
                  }
                  else if(idx==items.length+1){
                    return FutureBuilder(
                      future: snapshot.data.data["user_ref"].get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> userInfo){
                        if(userInfo.connectionState==ConnectionState.waiting){
                          return Text("....");
                        }
                        return Padding(
                          padding: EdgeInsets.all(5),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(//snapshot.data.data["delivery_location"]
                                    readOnly: true,
                                    controller: TextEditingController(text: userInfo.data["name"]),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Full Name',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(//snapshot.data.data["delivery_location"]
                                    readOnly: true,
                                    controller: TextEditingController(text: userInfo.data["mobile_no"]),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Mobile No',
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: TextField(//snapshot.data.data["delivery_location"]
                                    readOnly: true,
                                    controller: TextEditingController(text: snapshot.data.data["delivery_location"]),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Delevery Address',
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    showModalBottomSheet(context: context, builder: (buildContext){
                                      return Container(
                                        child: Column(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: (){
                                                FirebaseOrderUpdate.updateOrderStatus(orderId, 1);
                                                Navigator.pop(context);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Card(child: Container(width: MediaQuery.of(context).size.width,height: 70,child: Center(child: Padding(padding: EdgeInsets.all(10),child:
                                                Text(
                                                  "Processing",
                                                  style: TextStyle(fontSize: 19),
                                                )
                                                )))),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                FirebaseOrderUpdate.updateOrderStatus(orderId, 2);
                                                Navigator.pop(context);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Card(child: Container(width: MediaQuery.of(context).size.width,height: 70,child: Center(child: Padding(padding: EdgeInsets.all(10),child:
                                                Text(
                                                  "On the way",
                                                  style: TextStyle(fontSize: 19),
                                                )
                                                )))),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                FirebaseOrderUpdate.updateOrderStatus(orderId, 3);
                                                Navigator.pop(context);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Card(child: Container(width: MediaQuery.of(context).size.width,height: 70,child: Center(child: Padding(padding: EdgeInsets.all(10),child:
                                                Text(
                                                  "Deliverd",
                                                  style: TextStyle(fontSize: 19),
                                                )
                                                )))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Card(
                                          child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text("Change Status"))
                                      )
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }else{
                    return Padding(
                      padding: EdgeInsets.all(5),
                      child: Card(child: Column(
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    items[oderItemPosition]["name"],
                                    style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    items[oderItemPosition]["total_item"].toString(),
                                    style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                          ),
                          FadeInImage.assetNetwork(
                            placeholder: 'assets/empty_image.png',
                            image: items[oderItemPosition]['photo'],
                          )
                        ],
                      ),),
                    );
                  }
                },itemCount: items.length+2);
              },
            )
        )
    );

  }



}