class SignupProvider {

  final Map<String, dynamic> _signupPersonalData = {
    'first_name': null,
    'last_name': null,
    'email': null,
    'phone_number': null,
    'new_number': null,
    'password': null,
    'user_type': null,
     // 'location': null,
     // 'occupation': null,
     // 'rate': null,

  };
  final Map<String, dynamic> _signupBusinessData = {
    'business_type': null,
    'location': null,
  };
  final Map<String, dynamic> _signupDocumentData = {
    'document_type': null,
    'document_path': null,
  };

  get signupPersonalData => _signupPersonalData;
  get signupBusinessData => _signupBusinessData;
  get signupDocumentData => _signupDocumentData;

  void addMultipleDataSignup({required String firstName, required String lastName, required String email,required String phoneNumber,required String password,required userType}){
      _signupPersonalData['first_name'] = firstName;
      _signupPersonalData['last_name'] = lastName;
      _signupPersonalData['email'] = email;
      _signupPersonalData['phone_number'] = phoneNumber;
      _signupPersonalData['password'] = password;
      _signupPersonalData['user_type'] = userType;
  }

  void addDataSignup({required String key, required String value}){
      _signupPersonalData[key] = value;
  }

  void addMultipleDataBusiness({required String businessType, required String location, required String occupation}){
    _signupBusinessData['business_type'] = businessType;
    _signupBusinessData['location'] = location;
    _signupBusinessData['occupation'] = occupation;
  }

  void addDataBusiness({required String key, required String value}){
    _signupBusinessData[key] = value;
  }

  void addMultipleDataDocument({required String documentType, required String documentPath}){
    _signupDocumentData['document_type'] = documentType;
    _signupDocumentData['document_path'] = documentPath;
  }

  void addDataDocument({required String key, required String value}){
    _signupDocumentData[key] = value;
  }
}

