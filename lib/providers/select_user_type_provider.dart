import 'package:flutter/foundation.dart';
import 'package:bbpool/viewmodels/select_user_type_viewmodel.dart';

class SelectUserTypeProvider with ChangeNotifier {
  final SelectUserTypeViewModel _viewModel = SelectUserTypeViewModel();

  SelectUserTypeViewModel get viewModel => _viewModel;

  List get userTypes => _viewModel.userTypes;
  int get selectedIndex => _viewModel.selectedIndex;
  get selectedUserType => _viewModel.selectedUserType;
  bool get isValidSelection => _viewModel.isValidSelection;

  void selectUserType(int index) {
    _viewModel.selectUserType(index);
    notifyListeners();
  }

  /// ✅ Return "parent" or "driver" based on the selection
  String? getSelectedRole() {
    return _viewModel.getSelectedRole();
  }
}
