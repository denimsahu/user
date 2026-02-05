import 'package:cloud_firestore/cloud_firestore.dart';

class BusModel {
  late String BusNumber;
  late String DriverFirstName;
  late String DriverLastName;
  BusModel({
    required QueryDocumentSnapshot<Map<String, dynamic>> element,
  }){
    BusNumber= element.get("Vehicle Number");
    DriverFirstName= element.get("First Name");
    DriverLastName= element.get("Last Name");
  }
}