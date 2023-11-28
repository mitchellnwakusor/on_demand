import '../../Utilities/constants.dart';

class StartScreenProvider {
  late UserType? _userType;
  get userType => _userType;

  void selectUserType(UserType type) {
    _userType = type;
  }

}