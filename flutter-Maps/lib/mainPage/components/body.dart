import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashpark_client/components/text_field_container.dart';
import 'package:flashpark_client/registro/register.dart';
import 'package:flashpark_client/components/rounded_button.dart';
import 'package:flashpark_client/components/rounded_input_field.dart';
import 'package:flashpark_client/components/rounded_password_field.dart';
import 'package:flashpark_client/constants.dart';
import 'package:flashpark_client/mainPage/components/background.dart';
import 'package:flashpark_client/mapScreen/map.dart';
import 'package:flashpark_client/widgets/ConfigMaps.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String _email, _password;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              child: Image.asset(
                "assets/images/fplogov.png",
                width: size.width * 0.5,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            RoundedInputField(
              hintText: "Email",
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
            TextFieldContainer(
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Contraseña",
                  border: InputBorder.none,
                  icon: Icon(
                    Icons.lock,
                    color: orangePark,
                  ),
                  suffixIcon: Icon(
                    Icons.visibility,
                    color: orangePark,
                  ),
                ),
                onChanged: (value) {
                  _password = value.trim();
                },
              ),
            ),
            RoundedButton(
              text: "LOGIN",
              press: () => _signIn(_email, _password, context),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "¿No tienes cuenta? ",
                  style: TextStyle(color: Colors.black),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Register();
                        },
                      ),
                    );
                  },
                  child: Text(
                    "Regístrate ahora",
                    style: TextStyle(
                      color: orangePark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _signIn(String _email, String _password, BuildContext context) async {
    try {
      await auth.signInWithEmailAndPassword(email: _email, password: _password);

      //Success
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return MapScreen();
          },
        ),
      );
    } on FirebaseAuthException catch (error) {
      Fluttertoast.showToast(msg: error.message, gravity: ToastGravity.TOP);
    }
  }
}
