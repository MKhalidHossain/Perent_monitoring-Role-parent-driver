import 'package:bbpool/models/select_user_type_model.dart';
class SelectUserTypeViewModel {
  final List<SelectUserTypeModel> _userTypes = [
    SelectUserTypeModel(
      title: 'I m a Parent',
      description:
          'Book and track school rides for your child\nall in one place',
      iconPath: 'assets/images/parent_icon.png',
    ),
    SelectUserTypeModel(
      title: 'I m a Driver',
      description:
          'View routes, manage rides, and stay\nconnected with parents.',
      iconPath: 'assets/images/driver_icon.png',
    ),
  ];

  List<SelectUserTypeModel> get userTypes => _userTypes;

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  SelectUserTypeModel? get selectedUserType =>
      _selectedIndex >= 0 ? _userTypes[_selectedIndex] : null;

  void selectUserType(int index) {
    if (index >= 0 && index < _userTypes.length) {
      for (int i = 0; i < _userTypes.length; i++) {
        _userTypes[i] = _userTypes[i].copyWith(isSelected: false);
      }
      _userTypes[index] = _userTypes[index].copyWith(isSelected: true);
      _selectedIndex = index;
    }
  }

  bool get isValidSelection => _selectedIndex >= 0;

  /// ✅ Return "parent" or "driver" based on the selection
  String? getSelectedRole() {
    if (_selectedIndex == 0) return 'parent';
    if (_selectedIndex == 1) return 'driver';
    return null;
  }
}
