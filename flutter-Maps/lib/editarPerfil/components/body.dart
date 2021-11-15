import 'package:flashpark_client/components/rounded_button.dart';
import 'package:flashpark_client/components/rounded_input_field_general.dart';
import 'package:flashpark_client/editarPerfil/components/background.dart';
import 'package:flashpark_client/verPerfil/perfil.dart';
import 'package:flutter/material.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.02),
            CircleAvatar(
              child: Image.asset(
                "assets/images/avatar.png",
                //width: size.width*0.8,
              ),
              minRadius: 50,
              maxRadius: 75,

            ),
            RoundedInputFieldGeneral(
              hintText: "Correo",
              onChanged: (value){},
            ),
            RoundedInputFieldGeneral(
              hintText: "Contraseña",
              onChanged: (value){},
            ),
            RoundedInputFieldGeneral(
              hintText: "Nombre",
              onChanged: (value){},
            ),
            RoundedInputFieldGeneral(
              hintText: "Apellido",
              onChanged: (value){},
            ),
            RoundedInputFieldGeneral(
              hintText: "Celular",
              onChanged: (value){},
            ),
            RoundedInputFieldGeneral(
              hintText: "Tipo de Vehiculo",
              onChanged: (value){},
            ),
            RoundedInputFieldGeneral(
              hintText: "Placa",
              onChanged: (value){},
            ),
            RoundedButton(
              text: "Confirmar Cambios",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return VerPerfil();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}