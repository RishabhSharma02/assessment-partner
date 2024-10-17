import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EnterpriseController extends GetxController{
  int totalOrders=0;
  int inTransit=0;
  int cancelled=0;
  int totalFleet=0;
  double avgCost=0;
  int pending=0;
  @override
  void onInit() {
    _getMetrics();
    super.onInit();
  }
  var dbInstance=FirebaseFirestore.instance;
  void _getMetrics(){
    dbInstance.collection("orders").get().then(
      (val){
        if(val.docs.isNotEmpty){
          totalOrders=val.docs.length;
        }
        
      }
    );
    dbInstance.collection("orders").where("status",isEqualTo: "IN TRANSIT").get().then(
      (val){
        if(val.docs.isNotEmpty){
          inTransit=val.docs.length;
        }
        
      }
    );
    dbInstance.collection("orders").where("status",isEqualTo: "CANCELLED").get().then(
      (val){
        if(val.docs.isNotEmpty){
          cancelled=val.docs.length;
        }
        
      }
    );
    dbInstance.collection("vehicles").get().then(
      (val){
        if(val.docs.isNotEmpty){
          totalFleet=val.docs.length;
        }
        
      }
    );
    dbInstance.collection("orders").get().then(
      (val){
        if(val.docs.isNotEmpty){
          num sum=0;
          for(var i in val.docs){
            sum+=i.get("cashAlloted");
          }
          avgCost=sum/val.docs.length;
        }  
      }
    );
  }


}