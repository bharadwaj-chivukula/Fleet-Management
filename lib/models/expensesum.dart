class ExpenseSumModel{
  final String expenseType;
  final double amount;

  ExpenseSumModel({this.expenseType,this.amount});

  factory ExpenseSumModel.fromJson(Map<String,dynamic> json){
    return new ExpenseSumModel(
      expenseType: json['ExpenceType'],
      amount: double.parse(json['Amount'].toString()),
    );
  }  
}