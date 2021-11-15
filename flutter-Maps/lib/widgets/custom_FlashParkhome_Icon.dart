import 'package:flutter/material.dart';

class CustomImageFPHome extends StatelessWidget {
  const CustomImageFPHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Image.asset(
            "assets/images/fplogov.png",
            height: 150,
            width: 300,
          ),
        ],
      ),
    );
  }
}
