import 'package:budget_buddy/models/user_model.dart';
import 'package:budget_buddy/repository/auth_repository.dart';
import 'package:budget_buddy/utils/common.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  final _authRepo = AuthRepository();
  Status authStatus = Status.initial;
  String message = "";

  UserModel? _user;

  UserModel? get user => _user;

  set user(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  Future<void> signUp({
    required String fullname,
    required String email,
    required String password,
  }) async {
    if (authStatus == Status.loading) {
      return;
    }
    authStatus = Status.loading;
    notifyListeners();
    final res = await _authRepo.signUp(
        email: email, password: password, fullname: fullname);
    if (res.status == Status.success) {
      message = res.message;
      _user = res.data;
      authStatus = res.status;
      notifyListeners();
    } else {
      message = res.message;
      authStatus = res.status;
      notifyListeners();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    if (authStatus == Status.loading) {
      return;
    }
    authStatus = Status.loading;
    notifyListeners();
    final res = await _authRepo.signIn(email: email, password: password);
    if (res.status == Status.success) {
      message = res.message;
      _user = res.data;
      authStatus = res.status;
      notifyListeners();
    } else {
      message = res.message;
      authStatus = res.status;
      notifyListeners();
    }
  }

  Future<void> forgotPassword({required String email}) async {
    if (authStatus == Status.loading) {
      return;
    }
    authStatus = Status.loading;
    notifyListeners();

    final res = await _authRepo.forgotPassword(email: email);

    if (res.status == Status.success) {
      message = res.message;
      authStatus = res.status;
    } else {
      message = res.message;
      authStatus = res.status;
    }

    notifyListeners();
  }

  Future<void> logOut() async {
    if (authStatus == Status.loading) {
      return;
    }
    authStatus = Status.loading;
    notifyListeners();
    await _authRepo.signOut();
    authStatus = Status.success;
  }
}
