class LoginResponse {
  String status;
  String msg;
  Data data;

  LoginResponse({this.status, this.msg, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String hariUserid;
  String hariUseremail;
  String hariUsername;
  bool hariUserValidated;

  Data(
      {this.hariUserid,
        this.hariUseremail,
        this.hariUsername,
        this.hariUserValidated});

  Data.fromJson(Map<String, dynamic> json) {
    hariUserid = json['hari_userid'];
    hariUseremail = json['hari_useremail'];
    hariUsername = json['hari_username'];
    hariUserValidated = json['hari_user_validated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hari_userid'] = this.hariUserid;
    data['hari_useremail'] = this.hariUseremail;
    data['hari_username'] = this.hariUsername;
    data['hari_user_validated'] = this.hariUserValidated;
    return data;
  }
}