import 'package:flashpark_client/reservas/components/body.dart';
import 'package:flashpark_client/widgets/Menu_widget.dart';
import 'package:flashpark_client/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flashpark_client/constants.dart';
import 'package:flashpark_client/mapScreen/map.dart';
import 'package:flashpark_client/verPerfil/perfil.dart';

class VerReservas extends StatefulWidget {
  @override
  _VerReservasState createState() => _VerReservasState();
}

class _VerReservasState extends State<VerReservas> {
  int _index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reservas",
          style: TextStyles.appPartnerTextStyle
              .copyWith(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        toolbarHeight: 70,
        centerTitle: true,
      ),
      body: Body(),
      drawer: Menu().getDrawer(context),
    );
  }
}
