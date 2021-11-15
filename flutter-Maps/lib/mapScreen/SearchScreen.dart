import 'package:flashpark_client/Assistants/RequestAssistant.dart';
import 'package:flashpark_client/model/Address.dart';
import 'package:flashpark_client/model/PlacePrediction.dart';
import 'package:flashpark_client/widgets/ConfigMaps.dart';
import 'package:flashpark_client/widgets/Divider.dart';
import 'package:flashpark_client/widgets/Provider_Widget.dart';
import 'package:flashpark_client/widgets/text_styles.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController locationController = TextEditingController();
  List<PlacePrediction> placepredictionList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(color: Colors.orange, boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  blurRadius: 6,
                  spreadRadius: .5,
                  offset: Offset(0.7, 0.7))
            ]),
            child: Padding(
              padding:
                  EdgeInsets.only(left: 25, top: 20, right: 25, bottom: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      Center(
                          child: Text(
                        "¿A dónde te dirijes?",
                        style: TextStyles.appPartnerTextStyle.copyWith(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ))
                    ],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Icon(Icons.search),
                      SizedBox(
                        width: 18,
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: EdgeInsets.all(3),
                          child: TextField(
                            onChanged: (val) {
                              findPlace(val);
                            },
                            decoration: InputDecoration(
                                hintText: "Direccion de destino",
                                fillColor: Colors.white,
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(
                                    left: 11, top: 8, bottom: 8)),
                          ),
                        ),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          (placepredictionList.length) > 0
              ? Expanded(
                  //padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListView.separated(
                    padding: EdgeInsets.all(0),
                    itemBuilder: (context, index) {
                      return PreditionTile(
                        placePrediction: placepredictionList[index],
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        DividerWidget(),
                    itemCount: placepredictionList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void findPlace(String placename) async {
    if (placename.length > 1) {
      String autocompleteurl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placename&key=$mapKey&sessiontoken&components=country:co";
      var res = await RequestAssistant.getRequest(autocompleteurl);
      if (res == "failed") {
        return;
      }

      if (res["status"] == "OK") {
        var predictions = res["predictions"];
        var placeslist = (predictions as List)
            .map((e) => PlacePrediction.fromJson(e))
            .toList();
        setState(() {
          placepredictionList = placeslist;
        });
      }
    }
  }
}

class PreditionTile extends StatelessWidget {
  final PlacePrediction placePrediction;
  const PreditionTile({Key key, this.placePrediction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        getPlacesAddressDetails(placePrediction.place_id, context);
      },
      child: Column(
        children: [
          SizedBox(
            width: 10,
          ),
          Row(
            children: [
              Icon(
                Icons.location_city,
                color: Colors.orange,
              ),
              SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      placePrediction.main_text,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyles.appPartnerTextStyle.copyWith(fontSize: 16),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      placePrediction.secondary_text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.appPartnerTextStyle
                          .copyWith(fontSize: 12, color: Colors.orange),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
    );
  }

  void getPlacesAddressDetails(String placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(title: Text("Ubicando destino, por favor espere")));
    String placeDetailurl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
    var res = await RequestAssistant.getRequest(placeDetailurl);

    if (res == "failed") {
      return;
    }
    if (res["status"] == "OK") {
      Address address = Address();
      address.placeName = res["result"]["name"];

      address.placeID = placeId;

      address.latitud = res["result"]["geometry"]["location"]["lat"];

      address.longitud = res["result"]["geometry"]["location"]["lng"];

      Provider.of(context, listen: false)
          .appData
          .updateDestinyLocationAddress(address);
      print("This is destiny locations");
      print(address.placeName);
      Navigator.pop(context, address);
      Navigator.pop(context, address);
    }
  }
}
