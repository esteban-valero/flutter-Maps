import 'package:flashpark_client/components/text_field_container.dart';
import 'package:flutter/material.dart';

class RoundedInputFieldGeneral extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  const RoundedInputFieldGeneral({
    Key key,
    this.hintText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(25)),
          )
        ),
      ),
    );
  }
}
