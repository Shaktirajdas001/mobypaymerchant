class ChangePasswordModel {
  ChangePasswordModel({
    required this.status,
    required this.message,
  });
  late String status;
  late String message;

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'] ?? "";
    message = json['message'] ?? "";
  }
  ChangePasswordModel.fromError(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
