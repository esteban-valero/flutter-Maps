import 'package:flashpark_client/model/Address.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, destinyLocation;

  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDestinyLocationAddress(Address destinyAddress) {
    destinyLocation = destinyAddress;
    notifyListeners();
  }
}
