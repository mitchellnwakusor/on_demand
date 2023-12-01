class SignupProvider {

  final Map<String, dynamic> _signupPersonalData = {
    'first_name': null,
    'last_name': null,
    'email': null,
    'phone_number': null,
    'password': null,
    // 'location': null,
    // 'occupation': null,
    // 'plan': null,
  };

  get signupPersonalData => _signupPersonalData;

  void addMultipleData({required String firstName, required String lastName, required String email,required String phoneNumber,required String password}){
      _signupPersonalData['first_name'] = firstName;
      _signupPersonalData['last_name'] = lastName;
      _signupPersonalData['email'] = email;
      _signupPersonalData['phone_number'] = phoneNumber;
      _signupPersonalData['password'] = password;
  }

  void addData({required String key, required String value}){
      _signupPersonalData[key] = value;
  }

}

