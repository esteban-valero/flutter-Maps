import 'package:flashpark_client/model/User.dart';
import 'package:flashpark_client/verPerfil/perfil.dart';
import 'package:flashpark_client/widgets/PickImage.dart';
import 'package:flashpark_client/widgets/Provider_Widget.dart';
import 'package:flashpark_client/widgets/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditPerfil extends StatefulWidget {
  EditPerfil({Key key}) : super(key: key);

  @override
  _EditPerfilState createState() => _EditPerfilState();
}

class _EditPerfilState extends State<EditPerfil> {
  User user = new User("");
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final TextEditingController placaController = TextEditingController();
  final TextEditingController vehiController = TextEditingController();
  final GlobalKey<FormState> keyFor = new GlobalKey();
  bool showPassword = false;
  String dropdownValue = "";

  _getProfileData() async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    //print(Provider.of(context).db.collection('Partners').doc(uid).get());
    await Provider.of(context)
        .db
        .collection("users")
        .doc(uid)
        .get()
        .then((result) {
      user.phone = result.data()['celular'];
      user.name = result.data()['name'];
      user.email = result.data()['email'];
      user.image = result.data()['image'];
      user.pasword = result.data()['password'];
      user.placa = result.data()['placa'];
      user.vehiculo = result.data()['vehiculo'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editar Perfil",
          style: TextStyles.appPartnerTextStyle.copyWith(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        toolbarHeight: 70,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: FutureBuilder(
            future: _getProfileData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                emailController.text = user.email;
                nameController.text = user.name;
                phoneController.text = user.phone;
                passwordController.text = user.pasword;
                passwordConfirmController.text = user.pasword;
                placaController.text = user.placa;
                vehiController.text = user.vehiculo;
                dropdownValue = user.vehiculo;
                return ListView(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0, 10))
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      user.image,
                                    ))),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: Colors.orange,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageCapture(),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ))),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    Form(
                        key: keyFor,
                        child: Column(
                          children: [
                            buildTextField("Nombre", user.name, false,
                                nameController, validateName),
                            buildTextField("E-mail", user.email, false,
                                emailController, validateEmail),
                            buildTextField("Télefono", user.phone, false,
                                phoneController, validateMobile),
                            Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Vehiculo :",
                                    style: TextStyles.appPartnerTextStyle
                                        .copyWith(),
                                  ),
                                  getDropdownButton(),
                                ],
                              ),
                            ),
                            buildTextField("Placa", user.placa, false,
                                placaController, validateplaca),
                            buildTextField("Contraseña", user.pasword, true,
                                passwordController, validatePassword),
                            buildTextField(
                                "Confirmar Contraseña",
                                user.pasword,
                                true,
                                passwordConfirmController,
                                validatePassword),
                          ],
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlineButton(
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancelar",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.black)),
                        ),
                        RaisedButton(
                          onPressed: () async {
                            if (keyFor.currentState.validate()) {
                              user.name = nameController.text;
                              user.email = emailController.text;
                              user.phone = phoneController.text;
                              user.pasword = passwordController.text;
                              user.placa = placaController.text;
                              user.vehiculo = vehiController.text;

                              final uid = await Provider.of(context)
                                  .auth
                                  .getCurrentUID();
                              await Provider.of(context)
                                  .db
                                  .collection('user')
                                  .doc(uid)
                                  .update(user.toJson())
                                  .whenComplete(
                                      () => Navigator.of(context).pop())
                                  .catchError((error) =>
                                      print('Failed to update $error'));

                              keyFor.currentState.reset();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VerPerfil(),
                                ),
                              );
                            }
                          },
                          color: Colors.orange,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            "Guardar",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white),
                          ),
                        )
                      ],
                    )
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            }),

        /**/
      ),
    );
  }

  Widget getDropdownButton() {
    return DropdownButton(
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
  }

  Widget buildTextField(
      String labelText,
      String placeholder,
      bool isPasswordTextField,
      TextEditingController controller,
      String Function(String) validator) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPasswordTextField ? !showPassword : false,
        style: TextStyles.appPartnerTextStyle,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
        validator: validator,
      ),
    );
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

  String validatePassword(String value) {
    //print("valor $value passsword ${passwordController.text}");
    if (value.length == 0) return "La contraseña es necesaria";
    if (value != passwordController.text) {
      return "Las contraseñas no coinciden";
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
}
