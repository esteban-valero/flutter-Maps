import 'dart:async';
import 'dart:collection';
import 'package:flashpark_client/Assistants/AssistantMethods.dart';
import 'package:flashpark_client/constants.dart';
import 'package:flashpark_client/mapScreen/SearchScreen.dart';
import 'package:flashpark_client/model/Address.dart';
import 'package:flashpark_client/model/Parqueadero.dart';
import 'package:flashpark_client/reservarParqueadero/reservar.dart';
import 'package:flashpark_client/widgets/Divider.dart';
import 'package:flashpark_client/widgets/Provider_Widget.dart';
import 'package:flashpark_client/widgets/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flashpark_client/widgets/Menu_widget.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Address adressSelected = null;
  String addres = "";
  Position currentPosition;
  var geoLocator = Geolocator();
  Completer<GoogleMapController> _controllerGMap = Completer();
  GoogleMapController newGoogleMapController;
  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(4.628701373567275, -74.06468595987253), zoom: 14.5);
  double bottomPaddingOfMap = 0;

  Future<void> locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLngposition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLngposition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await AssistantMethods.searchCoordinatesAddress(position, context);
    this.addres = address;

    print("Esta es tu ubicacion:: " + address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FlashPark',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: orangePark,
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            markers: Set<Marker>.of(markers.values),
            onMapCreated: (GoogleMapController controller) {
              _controllerGMap.complete(controller);
              newGoogleMapController = controller;
              adressSelected == null ? locatePosition() : setDestiny();

              setState(() {
                bottomPaddingOfMap = 265;
              });
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black,
                        blurRadius: 16,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7))
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "!Hola de nuevo!",
                      style: TextStyles.appPartnerTextStyle
                          .copyWith(fontSize: 20.0, color: Colors.white),
                    ),
                    Text(
                      "¿A dónde te diriges ?",
                      style: TextStyles.appPartnerTextStyle
                          .copyWith(fontSize: 20.0, color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        searchDysplaySelection(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 6,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Buscar",
                                style: TextStyles.appPartnerTextStyle.copyWith(
                                    color: Colors.orange, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      drawer: Menu().getDrawer(context),
    );
  }

  void searchDysplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final Address result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search()),
    );
    if (result != null) {
      print('Resultado');
      print(result.placeName);
      setState(() {
        adressSelected = result;
      });
      setDestiny();
      getMarkerData();
    }
  }

  Future<void> setDestiny() async {
    final GoogleMapController controller = await _controllerGMap.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(adressSelected.latitud, adressSelected.longitud),
            zoom: 15.0),
      ),
    );
  }

  getMarkerData() async {
    await Provider.of(context)
        .db
        .collection('Parkings')
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Parking parking = new Parking(
            result.data()['Bike Capacity'],
            result.data()['Car Capacity'],
            result.data()['Motorcycle Capacity'],
            result.data()['Scooters Capacity'],
            result.data()['Name'],
            result.data()['address'],
            result.data()['IDParking'],
            result.data()['IDPartner'],
            result.data()['Latitud'],
            result.data()['Longitud']);

        var markerIdVal = result.data()['IDParking'];
        final MarkerId markerId = MarkerId(markerIdVal);
        final Marker marker = Marker(
            markerId: markerId,
            position:
                LatLng(result.data()['Latitud'], result.data()['Longitud']),
            infoWindow: InfoWindow(title: result.data()['Name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReservarParqueadero(parking)),
              );
            });
        setState(() {
          markers[markerId] = marker;
        });
      });
    });
  }

  void initMarker(specify, specifyId) async {
    var markerIdVal = specifyId;
    final MarkerId markerId = MarkerId(markerIdVal);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(specify.data()['Latitud'], specify.data()['Longitud']),
      infoWindow: InfoWindow(
          title: 'FlashPark Parking', snippet: specify.data()['name']),
    );
    setState(() {
      markers[markerId] = marker;
    });
  }
}
