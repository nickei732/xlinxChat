class LoginResponse {
   int code;
   String info;
   Data data;

  LoginResponse({ this.code,  this.info,  this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    info = json['info'];
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['info'] = this.info;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
   String token;
   String uid;
   String username;
   String profileImage;

  Data({ this.token,  this.uid,  this.username,  this.profileImage});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    uid = json['uid'];
    username = json['username'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['uid'] = this.uid;
    data['username'] = this.username;
    data['profile_image'] = this.profileImage;
    return data;
  }
}