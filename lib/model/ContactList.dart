class CategoryList {
  String status;
  List<CategoryData> data;

  CategoryList({this.status, this.data});

  CategoryList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = new List<CategoryData>();
      json['data'].forEach((v) {
        data.add(new CategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryData {
  String customerId;
  String customerFname;
  String customerLname;
  String customerPhoto;
  String customerMobile;
  String whatsappMobile;
  String customerGender;
  String customerAddress;
  String customerPincode;
  String countryId;
  String stateId;
  String cityId;
  String customerEmail;
  String customerPassword;
  String customerRegDate;
  String customerRegIp;
  String customerVerifyMobile;
  String customerOtp;
  String customerResetPwdDate;
  String customerResetPwdCode;
  String isActive;
  String isDelete;
  String userCode;
  String isVerifiedmail;
  String isVerifiedmobile;

  CategoryData(
      {this.customerId,
      this.customerFname,
      this.customerLname,
      this.customerPhoto,
      this.customerMobile,
      this.whatsappMobile,
      this.customerGender,
      this.customerAddress,
      this.customerPincode,
      this.countryId,
      this.stateId,
      this.cityId,
      this.customerEmail,
      this.customerPassword,
      this.customerRegDate,
      this.customerRegIp,
      this.customerVerifyMobile,
      this.customerOtp,
      this.customerResetPwdDate,
      this.customerResetPwdCode,
      this.isActive,
      this.isDelete,
      this.userCode,
      this.isVerifiedmail,
      this.isVerifiedmobile});

  CategoryData.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    customerFname = json['customer_fname'];
    customerLname = json['customer_lname'];
    customerPhoto = json['customer_photo'];
    customerMobile = json['customer_mobile'];
    whatsappMobile = json['whatsapp_mobile'];
    customerGender = json['customer_gender'];
    customerAddress = json['customer_address'];
    customerPincode = json['customer_pincode'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    customerEmail = json['customer_email'];
    customerPassword = json['customer_password'];
    customerRegDate = json['customer_reg_date'];
    customerRegIp = json['customer_reg_ip'];
    customerVerifyMobile = json['customer_verify_mobile'];
    customerOtp = json['customer_otp'];
    customerResetPwdDate = json['customer_reset_pwd_date'];
    customerResetPwdCode = json['customer_reset_pwd_code'];
    isActive = json['is_active'];
    isDelete = json['is_delete'];
    userCode = json['user_code'];
    isVerifiedmail = json['is_verifiedmail'];
    isVerifiedmobile = json['is_verifiedmobile'];
  }

  factory CategoryData.fromMap(Map<String, dynamic> data) => CategoryData(
        customerId: data['customer_id'],
        customerFname: data['customer_fname'],
        customerLname: data['customer_lname'],
        customerPhoto: data['customer_photo'],
        customerMobile: data['customer_mobile'],
        whatsappMobile: data['whatsapp_mobile'],
        customerGender: data['customer_gender'],
        customerAddress: data['customer_address'],
        customerPincode: data['customer_pincode'],
        countryId: data['country_id'],
        stateId: data['state_id'],
        cityId: data['city_id'],
        customerEmail: data['customer_email'],
        customerPassword: data['customer_password'],
        customerRegDate: data['customer_reg_date'],
        customerRegIp: data['customer_reg_ip'],
        customerVerifyMobile: data['customer_verify_mobile'],
        customerOtp: data['customer_otp'],
        customerResetPwdDate: data['customer_reset_pwd_date'],
        customerResetPwdCode: data['customer_reset_pwd_code'],
        isActive: data['is_active'],
        isDelete: data['is_delete'],
        userCode: data['user_code'],
        isVerifiedmail: data['is_verifiedmail'],
        isVerifiedmobile: data['is_verifiedmobile'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = this.customerId;
    data['customer_fname'] = this.customerFname;
    data['customer_lname'] = this.customerLname;
    data['customer_photo'] = this.customerPhoto;
    data['customer_mobile'] = this.customerMobile;
    data['whatsapp_mobile'] = this.whatsappMobile;
    data['customer_gender'] = this.customerGender;
    data['customer_address'] = this.customerAddress;
    data['customer_pincode'] = this.customerPincode;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['customer_email'] = this.customerEmail;
    data['customer_password'] = this.customerPassword;
    data['customer_reg_date'] = this.customerRegDate;
    data['customer_reg_ip'] = this.customerRegIp;
    data['customer_verify_mobile'] = this.customerVerifyMobile;
    data['customer_otp'] = this.customerOtp;
    data['customer_reset_pwd_date'] = this.customerResetPwdDate;
    data['customer_reset_pwd_code'] = this.customerResetPwdCode;
    data['is_active'] = this.isActive;
    data['is_delete'] = this.isDelete;
    data['user_code'] = this.userCode;
    data['is_verifiedmail'] = this.isVerifiedmail;
    data['is_verifiedmobile'] = this.isVerifiedmobile;
    return data;
  }
}
