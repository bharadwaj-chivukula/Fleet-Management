class ResultModel{
  final bool status;
  final String successMessage;
  final String errorMessage;

  ResultModel({this.status,this.successMessage,this.errorMessage});

  factory ResultModel.fromJson(Map<String,dynamic> json){
    return new ResultModel(
      status: json['Status'],
      successMessage: json['SuccessMessage'],
      errorMessage: json['ErrorMessage'],   
    );
  }
}