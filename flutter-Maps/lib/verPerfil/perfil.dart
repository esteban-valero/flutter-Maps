import 'package:flashpark_client/mapScreen/map.dart';
import 'package:flashpark_client/reservas/reservas.dart';
import 'package:flashpark_client/verPerfil/components/body.dart';
import 'package:flashpark_client/widgets/Menu_widget.dart';
import 'package:flashpark_client/widgets/text_styles.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class VerPerfil extends StatefulWidget {
  @override
  _VerPerfilState createState() => _VerPerfilState();
}

class _VerPerfilState extends State<VerPerfil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      drawer: Menu().getDrawer(context),
      appBar: AppBar(
        title: Text(
          "Perfil",
          style: TextStyles.appPartnerTextStyle.copyWith(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        toolbarHeight: 70,
        centerTitle: true,
      ),
    );
  }
}
