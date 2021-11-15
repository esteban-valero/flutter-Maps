import 'package:flashpark_client/editarPerfil/components/body.dart';
import 'package:flashpark_client/mapScreen/map.dart';
import 'package:flashpark_client/reservas/reservas.dart';
import 'package:flashpark_client/verPerfil/perfil.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class EditarPerfil extends StatefulWidget {
  @override
  _EditarPerfilState createState() => _EditarPerfilState();
}

class _EditarPerfilState extends State<EditarPerfil> {
  int _index = 2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
      bottomNavigationBar: new Theme(
        data: Theme.of(context).copyWith(
            canvasColor: orangePark,
            primaryColor: Colors.black,
            textTheme: Theme
                .of(context)
                .textTheme
                .copyWith(caption: new TextStyle(color: orangePark))), // sets the inactive color of the `BottomNavigationBar`
        child: new BottomNavigationBar(
          currentIndex: _index,
          onTap: (int index) {
            setState(() {
              this._index = index;
            }
            );
            _navigateToScreens(index);
          },
          items: [
            new BottomNavigationBarItem(
              icon: new Icon(Icons.map),
              label: "Mapa",
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.car_repair),
              label: "Parqueaderos",
            ),
            new BottomNavigationBarItem(
              icon: new Icon(Icons.person),
              label: "Perfil",
            )
          ],
        ),
      ),
    );
  }

  _navigateToScreens(int index){
    if(index == 0){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MapScreen();
          },
        ),
      );
    }
    if(index == 1){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return VerReservas();
          },
        ),
      );
    }
    if(index == 2){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return VerPerfil();
          },
        ),
      );
    }
  }
}
