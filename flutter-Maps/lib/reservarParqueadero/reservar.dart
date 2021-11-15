import 'package:flashpark_client/mapScreen/map.dart';
import 'package:flashpark_client/model/Parqueadero.dart';
import 'package:flashpark_client/reservas/reservas.dart';
import 'package:flashpark_client/verPerfil/perfil.dart';
import 'package:flashpark_client/widgets/Menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flashpark_client/reservarParqueadero/components/body.dart';

import '../constants.dart';

class ReservarParqueadero extends StatefulWidget {
  Parking parking;
  ReservarParqueadero(Parking p) {
    this.parking = p;
  }
  @override
  _ReservarParqueaderoState createState() => _ReservarParqueaderoState();
}

class _ReservarParqueaderoState extends State<ReservarParqueadero> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reservar',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: orangePark,
      ),
      body: Body(widget.parking),
      drawer: Menu().getDrawer(context),
    );
  }
}
