class XlinxLoginResponse {
  bool error;
  String message;
  String a;
  String token;

  XlinxLoginResponse({this.error, this.message, this.a, this.token});

  XlinxLoginResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    a = json['a'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    data['a'] = this.a;
    data['token'] = this.token;
    return data;
  }
}