class UserData{
  String? firName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? dateOfBirth;

  static UserData instance = UserData._init();

  UserData._init();

  UserData({
    this.firName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.dateOfBirth
  });

  setData(Map<String,dynamic> data){
    firName = data['first_name'];
    lastName = data['last_name'];
    email = data['email'];
    phoneNumber = data['phone_number'];
    dateOfBirth = data['date_of_birth'];
}

  UserData getUserData(){
    return UserData.instance;
  }
  }
