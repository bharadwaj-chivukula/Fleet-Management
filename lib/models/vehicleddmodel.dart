class VehicleDdModel{
  final int id;
  final String vin;
  final String registrationNo;

  VehicleDdModel({this.id,this.vin,this.registrationNo});

  factory VehicleDdModel.fromJson(Map<String,dynamic> json){
    return new VehicleDdModel(
      id: json['Id'],
      vin: json['VIN'],
      registrationNo: json['RegistrationNo']
    );
  }
}