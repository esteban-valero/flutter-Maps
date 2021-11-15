import 'dart:convert';

import 'package:flashpark_client/components/rounded_button.dart';
import 'package:flashpark_client/components/rounded_input_field_general.dart';
import 'package:flashpark_client/mapScreen/map.dart';
import 'package:flashpark_client/model/Parqueadero.dart';
import 'package:flashpark_client/reservarParqueadero/components/background.dart';
import 'package:flashpark_client/reservas/reservas.dart';
import 'package:flashpark_client/widgets/ConfigMaps.dart';
import 'package:flashpark_client/widgets/Provider_Widget.dart';
import 'package:flashpark_client/widgets/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Body extends StatefulWidget {
  Parking p;
  Body(Parking p) {
    this.p = p;
  }

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String dropdownValue = 'Carro';
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  DateTime _date = DateTime(2021, 11, 17);
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  TextEditingController placaController = new TextEditingController();

  final GlobalKey<FormState> keyForm = new GlobalKey();

  void _selectDate() async {
    final DateTime newDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2017, 1),
      lastDate: DateTime(2022, 7),
      helpText: 'selecciona una fecha',
    );
    if (newDate != null) {
      setState(() {
        _date = newDate;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
    final placa = TextFormField(
        controller: placaController,
        obscureText: false,
        style: TextStyles.appPartnerTextStyle,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Placa",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.orange),
            )),
        validator: validateplaca);

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
            final uid = await Provider.of(context).auth.getCurrentUID();
            showDialog(
                context: context,
                builder: (BuildContext context) =>
                    AlertDialog(title: Text("Reservando, por favor espere")));

            if (await Provider.of(context).auth.createReservation(
                    widget.p.idParking,
                    uid,
                    dropdownValue,
                    placaController.text,
                    DateFormat('yyyy-MM-dd').format(_date),
                    _time.format(context).toString()) ==
                "Reservado") {
              print('Reservado');
              await sendNot();
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerReservas(),
                  ));
            } else
              CircularProgressIndicator();

            keyForm.currentState.reset();
          }
        },
        child: Text("Reservar",
            textAlign: TextAlign.center,
            style: TextStyles.appPartnerTextStyle
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.p.name,
              style: TextStyles.appPartnerTextStyle.copyWith(fontSize: 30),
            ),
            SizedBox(height: size.height * 0.02),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              onPressed: _selectDate,
              child: Text('SELECCIONE UNA FECHA'),
            ),
            SizedBox(height: 8),
            Text(
              'Fecha seleccionada: \n\t\t\t\t\t\t\t${DateFormat('yyyy-MM-dd').format(_date)}',
              style: TextStyles.appPartnerTextStyle.copyWith(fontSize: 20),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.orange),
              onPressed: _selectTime,
              child: Text('SELECCIONE UNA HORA'),
            ),
            SizedBox(height: 8),
            Text(
              'Hora: ${_time.format(context)}',
              style: TextStyles.appPartnerTextStyle.copyWith(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Seleccione el tipo de vehiculo:',
              style: TextStyles.appPartnerTextStyle.copyWith(fontSize: 20),
            ),
            vehiculo,
            SizedBox(height: 8),
            Container(
              child: Form(
                  key: keyForm,
                  child: Column(
                    children: [
                      placa,
                    ],
                  )),
            ),
            SizedBox(height: 8),
            registerButton
          ],
        ),
      ),
    );
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

  Future<Response> sendNotification(
      List<String> tokenIdList, String contents, String heading) async {
    return await post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id":
            onekey, //kAppId is the App Id that one get from the OneSignal When the application is registered.

        "include_player_ids":
            tokenIdList, //tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

        // android_accent_color reprsent the color of the heading text in the notifiction
        "android_accent_color": "FF9800",

        "small_icon":
            "https://firebasestorage.googleapis.com/v0/b/flashpark-8dd19.appspot.com/o/FCMImages%2FFLASHPARKicono.png?alt=media&token=a88e9dcd-9512-46f3-aed0-ebc603b629d5",

        "large_icon":
            "https://firebasestorage.googleapis.com/v0/b/flashpark-8dd19.appspot.com/o/FCMImages%2FFLASHPARKicono.png?alt=media&token=a88e9dcd-9512-46f3-aed0-ebc603b629d5",

        "headings": {"en": heading},

        "contents": {"en": contents},
      }),
    );
  }

  Future<void> sendNot() async {
    final uid = widget.p.idPartner;
    print(uid);
    List<String> tokenId = [];

    await Provider.of(context)
        .db
        .collection("Partners")
        .doc(uid)
        .get()
        .then((result) {
      tokenId.add(result.data()["tokenId"]);
    });
    sendNotification(
        tokenId,
        "¡Has recibido una nueva reserva para tu parqueadero ${widget.p.name}!",
        "¡Has recibido una nueva reserva!");
  }
}
