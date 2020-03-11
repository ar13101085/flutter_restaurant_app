
import 'package:flutter/material.dart';
import 'package:restaurant_user_demo/model/cart.dart';

class CartProvider extends ChangeNotifier {
  Map<String,Cart> cartList=new Map<String,Cart>();
  addItem(Cart item){
     if(cartList.containsKey(item.productId)){
       cartList[item.productId].totalItem++;
     }else{
       cartList[item.productId]=item;
     }
     notifyListeners();
  }

  void removeItem(Cart item){
    if(cartList.containsKey(item.productId)){
      if(cartList[item.productId].totalItem>1){
        cartList[item.productId].totalItem--;
      }else{
        cartList.remove(item.productId);
      }
    }
    notifyListeners();
  }

  int totalItem(){
    int sum=0;
    cartList.values.forEach((item){
      sum+=item.totalItem;
    });
    return sum;
  }
  void clearAll(){
    cartList.clear();
    notifyListeners();
  }


}
