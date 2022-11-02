class ExpenseTypeModel{
  final int id;
  final String expenseType;
  final String description;

  ExpenseTypeModel({this.id,this.expenseType,this.description});

  factory ExpenseTypeModel.fromJson(Map<String,dynamic> json){
    return new ExpenseTypeModel(
      id: json['Id'],
      expenseType: json['ExpenseType'],
      description: json['Description']         
    );
  }
}