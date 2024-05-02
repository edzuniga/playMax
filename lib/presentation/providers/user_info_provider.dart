import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_info_provider.g.dart';

@Riverpod(keepAlive: true)
class UserInfo extends _$UserInfo {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  //Set the current logged in user information
  void setUserInfo(Map<String, dynamic> userInfo) {
    state.addAll(userInfo);
  }

  //Return to the initital state of the app (during logout)
  void clearUserInfo() {
    state.clear();
  }
}
