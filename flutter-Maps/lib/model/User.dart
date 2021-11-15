class User {
  String phone;
  String name;
  String pasword;
  String email;
  String vehiculo;
  String placa;
  String image;

  User(this.phone);

  Map<String, dynamic> toJson() => {
        'celular': phone,
        'email': email,
        'name': name,
        'placa': placa,
        'vehiculo': vehiculo,
        'password': pasword,
        'image': image
      };
}
