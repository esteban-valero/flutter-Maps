class Reserve {
  String estado;
  String idParking;
  String idUser;
  String hora;
  String time;
  String vehiculo;
  String placa;
  String reserID;

  Reserve(this.estado, this.idParking, this.idUser, this.time, this.vehiculo,
      this.hora, this.placa, this.reserID);

  Map<String, dynamic> toJson() => {
        'Estado': estado,
        'IDParking': idParking,
        'IDUser': idUser,
        'Hora': hora,
        'vehiculo': vehiculo,
        'Time': time,
        'placa': placa,
        'reserID': reserID
      };
}
