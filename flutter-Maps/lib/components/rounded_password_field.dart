import 'package:flashpark_client/components/text_field_container.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            color: orangePark,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: orangePark,
          ),
          hintText: "Contraseña",
          border: InputBorder.none,
        ),
      ),
    );
  }
}