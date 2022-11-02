class ExpenseModel{
  final int expenseId;
  final int orgId;
  final int userId;
  final int expenseTypeId;
  final int vehicleId;
  final DateTime expenseDate;
  final double amount;
  final String notes;
  final String vin;
  final String expenseType;
  final String registrationNo;
  final double odometerReading;
  final double quantity;

  ExpenseModel({this.expenseTypeId,this.orgId,this.userId,
  this.expenseId,this.vehicleId,this.expenseDate,this.amount,
  this.notes,this.vin,this.expenseType,this.registrationNo,
  this.odometerReading,this.quantity});

    factory ExpenseModel.fromJson(Map<String,dynamic> json){
    return new ExpenseModel(
      expenseId: json['Id'],
      orgId: json['OrgId'],
      expenseTypeId: json['ExpenseTypeId'],
      vehicleId: json["VehicleId"],
      expenseDate: DateTime.parse(json['DateOfTransaction']),
      amount: json["Amount"],
      notes: json["Notes"],
      vin: json["VIN"],
      expenseType: json["ExpenseType"],
      registrationNo: json['Registration'],
      odometerReading: json["Odometer"],
      quantity: json["Quantity"]
    );
  }
}