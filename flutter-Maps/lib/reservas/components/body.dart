import 'package:flashpark_client/components/rounded_button.dart';
import 'package:flashpark_client/model/Reserve%20copy.dart';
import 'package:flashpark_client/reservas/components/background.dart';
import 'package:flashpark_client/widgets/Provider_Widget.dart';
import 'package:flashpark_client/widgets/text_styles.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Reserve> reserves = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            FutureBuilder(
                future: _getReservationData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                          itemCount: reserves.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Dismissible(
                                key: Key(reserves[index].reserID),
                                background: Container(
                                  color: Colors.green,
                                  child: Icon(Icons.check),
                                ),
                                secondaryBackground: Container(
                                  color: Colors.red,
                                  child: Icon(Icons.cancel),
                                ),
                                onDismissed: (D) async {
                                  if (D == DismissDirection.endToStart) {
                                    print("Cambiando a terminado");
                                    reserves[index].estado = 'Terminado';
                                    await Provider.of(context)
                                        .db
                                        .collection('Reservations')
                                        .doc(reserves[index].reserID.trim())
                                        .update(reserves[index].toJson())
                                        .whenComplete(() => setState(() {}))
                                        .catchError((error) =>
                                            print('Failed to update $error'));
                                  }
                                  if (D == DismissDirection.startToEnd) {
                                    reserves[index].estado = 'En curso';
                                    await Provider.of(context)
                                        .db
                                        .collection('Reservations')
                                        .doc(reserves[index].reserID.trim())
                                        .update(reserves[index].toJson())
                                        .whenComplete(() => setState(() {}))
                                        .catchError((error) =>
                                            print('Failed to update $error'));
                                  }
                                },
                                child: ListTile(
                                  trailing: Icon(
                                    reserves[index].vehiculo == 'Carro'
                                        ? Icons.car_repair
                                        : reserves[index].vehiculo == 'Moto'
                                            ? Icons.motorcycle
                                            : reserves[index].vehiculo ==
                                                    'Bicicleta'
                                                ? Icons.pedal_bike
                                                : Icons.electric_scooter,
                                    color: reserves[index].estado == 'nueva'
                                        ? Colors.orangeAccent
                                        : reserves[index].estado == 'En curso'
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  subtitle: Text(
                                    " ${reserves[index].time}  / ${reserves[index].hora} ",
                                    style: TextStyles.appPartnerTextStyle
                                        .copyWith(),
                                    textAlign: TextAlign.center,
                                  ),
                                  title: Text(
                                    " ${reserves[index].placa} ",
                                    style: TextStyles.appPartnerTextStyle
                                        .copyWith(),
                                    textAlign: TextAlign.center,
                                  ),
                                  onTap: () {
                                    /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CustomDetailParking(
                                        parking: parkings[index],
                                      ),
                                    ),
                                  );*/
                                  },
                                ),
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom:
                                          BorderSide(color: Colors.orange))),
                            );
                          },
                        ));
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          ],
        ),
      ),
    );
  }

  _getReservationData() async {
    reserves = [];
    var uid = await Provider.of(context).auth.getCurrentUID();
    //print(Provider.of(context).db.collection('Partners').doc(uid).get());
    await Provider.of(context)
        .db
        .collection("Reservations")
        .where('IDUser', isEqualTo: uid)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        Reserve r = Reserve(
            result.data()['Estado'],
            result.data()['IDParking'],
            result.data()['IDUser'],
            result.data()['Time'],
            result.data()['vehiculo'],
            result.data()['Hora'],
            result.data()['placa'],
            result.data()['reserID']);
        print('placa');
        print(r.placa);
        reserves.add(r);
      });
    });
    print('TRY TO GET RESERVATIONS');
  }
}
