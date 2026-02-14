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

  Duration waitingTime() {
    return seatedTime.difference(joinedQueueTime);
  }

  String formatMMSS(Duration d) {
    final minutes = d.inMinutes % 60; 
    final seconds = d.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')} min';
  }

  void addNewOrder(OrderDetail orderDetail){
    orderDetails.add(orderDetail);
  }
}