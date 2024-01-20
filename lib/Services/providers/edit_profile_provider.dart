
class EditProfileProvider{
  String? _newNumber;
  String? _newEmail;

  String? get newNumber => _newNumber;
  String? get newEmail => _newEmail;

  void setNewNumber(String? number) {
   _newNumber = number;
  }
  void setNewEmail(String? email) {
    _newEmail = email;
  }


}