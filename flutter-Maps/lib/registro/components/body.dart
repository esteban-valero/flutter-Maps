import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashpark_client/mainPage/mainPage.dart';
import 'package:flashpark_client/registro/TermsOfUse.dart';
import 'package:flashpark_client/widgets/Provider_Widget.dart';
import 'package:flashpark_client/registro/components/background.dart';
import 'package:flashpark_client/mapScreen/map.dart';
import 'package:flashpark_client/widgets/text_styles.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placaController = TextEditingController();
  final TextEditingController phonrController = TextEditingController();
  final GlobalKey<FormState> keyForm = new GlobalKey();
  final bool agree = false;
  String email, password, nombre, celular, vehiculo, placaS;
  bool show = false;
  final auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  String dropdownValue = 'Carro';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    String validatePassword(String value) {
      //print("valor $value passsword ${passwordController.text}");
      if (value.length == 0) return "La contraseña es necesaria";
      if (value != passwordController.text) {
        return "Las contraseñas no coinciden";
      }
      return null;
    }

    final emailField = TextFormField(
        controller: emailController..text = email,
        obscureText: false,
        onChanged: (value) => email = value,
        style: TextStyles.appPartnerTextStyle,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "E-mail",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.orange),
            )),
        validator: validateEmail);

    final name = TextFormField(
        controller: nameController..text = nombre,
        obscureText: false,
        onChanged: (value) => nombre = value,
        style: TextStyles.appPartnerTextStyle,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Nombre",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.orange),
            )),
        validator: validateName);

    final placa = TextFormField(
        controller: placaController..text = placaS,
        obscureText: false,
        onChanged: (value) => placaS = value,
        style: TextStyles.appPartnerTextStyle,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Placa",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.orange),
            )),
        validator: validateplaca);

    final vehiculo = DropdownButton(
      value: dropdownValue,
      icon: Icon(
        Icons.arrow_downward,
        color: Colors.orange,
      ),
      underline: Container(
        height: 2,
        color: Colors.deepOrange,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Carro', 'Moto', 'Bicicleta', 'Scooter']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyles.appPartnerTextStyle,
          ),
        );
      }).toList(),
    );

    final phone = TextFormField(
        controller: phonrController..text = celular,
        obscureText: false,
        onChanged: (value) => celular,
        style: TextStyles.appPartnerTextStyle,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Télefono",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.orange),
            )),
        validator: validateMobile);

    final passwordField = TextFormField(
        controller: passwordController..text = password,
        obscureText: true,
        style: TextStyles.appPartnerTextStyle,
        onChanged: (value) => password = value,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Contraseña",
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.orange))));

    final passwordFieldConf = TextFormField(
        controller: passwordConfirmController,
        obscureText: true,
        style: TextStyles.appPartnerTextStyle,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Contraseña",
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.orange))),
        validator: validatePassword);

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        color: Colors.orange,
        minWidth: MediaQuery.of(context).size.width / 2,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (keyForm.currentState.validate()) {
            final auth = Provider.of(context).auth;

            if (await auth.signUp(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    placaController.text.trim(),
                    nameController.text.trim(),
                    dropdownValue,
                    phonrController.text.trim()) ==
                "Signed UP") {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MapScreen()));
            } else
              CircularProgressIndicator();

            keyForm.currentState.reset();
          }
        },
        child: Text("Registrarse, aceptando terminos y condiciones",
            textAlign: TextAlign.center,
            style: TextStyles.appPartnerTextStyle
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final loginNow = TextButton(
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        )
      },
      child: Text("¡Inicia sesión aqui!",
          textAlign: TextAlign.center,
          style: TextStyles.appPartnerTextStyle
              .copyWith(color: Colors.grey, fontSize: 15)),
    );

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 300,
              child: Image.asset(
                "assets/images/fplogov.png",
                width: size.width * 0.5,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: new Form(
                key: keyForm,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    emailField,
                    SizedBox(height: 20.0),
                    name,
                    SizedBox(height: 20.0),
                    placa,
                    SizedBox(height: 20.0),
                    Text(
                      "Seleccione el tipo de vehiculo",
                      style: TextStyles.appPartnerTextStyle,
                    ),
                    vehiculo,
                    SizedBox(height: 20.0),
                    passwordField,
                    SizedBox(height: 20.0),
                    passwordFieldConf,
                    SizedBox(height: 20.0),
                    phone,
                    SizedBox(height: 20.0),
                    registerButton,
                    SizedBox(height: 10.0),
                    TermsOfUse(),
                    Text("¿Ya tienes una cuenta?"),
                    loginNow
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String validateName(String value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "El nombre es necesario";
  } else if (!regExp.hasMatch(value)) {
    return "El nombre debe de ser a-z y A-Z";
  }
  return null;
}

String validateplaca(String value) {
  String pattern = r'(^[A-Z]{3}\d{3}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "La placa es necesaria";
  } else if (!regExp.hasMatch(value)) {
    return "La placa debe ser de formato AAA111";
  }
  return null;
}

String validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "El correo es necesario";
  } else if (!regExp.hasMatch(value)) {
    return "Correo invalido";
  } else {
    return null;
  }
}

String validateMobile(String value) {
  String patttern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "El telefono es necesario";
  } else if (!regExp.hasMatch(value)) {
    return "El telefono solo debe contener numeros";
  } else if (value.length != 10) {
    return "El numero debe tener 10 digitos";
  }
  return null;
}
