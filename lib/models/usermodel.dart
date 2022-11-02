class UserModel {
  final int orgId;
  final int userId;
  final String userName;
  final String emailId;

  UserModel({this.orgId, this.userId, this.userName, this.emailId});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      return new UserModel(
          orgId: json['OrgId'],
          userId: json['UserId'],
          userName: json['UserName'],
          emailId: json['Email']);
    } else {
      return new UserModel();
    }
  }
}
