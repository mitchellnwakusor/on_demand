import '../../Utilities/constants.dart';

class StartScreenProvider {
  late UserType? _userType;
  get userType => _userType;

  void saveUserType(UserType type) {
    _userType = type;
  }

}