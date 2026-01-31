import 'package:flutter/material.dart';

enum Status {
  serving(Color.fromRGBO(255, 104, 53, 1)),
  completed(Color.fromRGBO(16, 185, 129, 1)),
  noShow(Color.fromRGBO(230, 57, 70, 1)),
  cancelled(Color.fromRGBO(255, 191, 0, 1));

  final Color color;
  const Status(this.color);
}

enum JoinedMethod{
  remotely, walkIn,
}

class OrderDetail{
  final String menuName;
  final int quantity;
  final double unitPrice;
  
  const OrderDetail({required this.menuName, required this.quantity, required this.unitPrice});

  double totalPrice(){
    return quantity * unitPrice;
  }
}

class StoreQueueHistory {
  final String customerName;
  final DateTime joinedQueueTime;
  final DateTime seatedTime;
  final Status currentStatus;
  final String queueNumber;
  final int numberOfGuests;
  final JoinedMethod joinedMethod;
  final DateTime endedTime;
  List<OrderDetail> orderDetails = [];

  StoreQueueHistory({required this.customerName, required this.joinedQueueTime, required this.seatedTime, required this.currentStatus, required this.queueNumber, required this.numberOfGuests, required this.joinedMethod, required this.endedTime});

  double grandTotal(){
    double grandTotal = 0;
    if(orderDetails.isNotEmpty){
      for(OrderDetail order in orderDetails){
        grandTotal += order.totalPrice();
      }
    }
    return grandTotal;
  }

  String waitingTime(){
    int totalSeconds = seatedTime.difference(joinedQueueTime).inSeconds;

    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '$minutes:$seconds';
  } 

  void addNewOrder(OrderDetail orderDetail){
    orderDetails.add(orderDetail);
  }
}