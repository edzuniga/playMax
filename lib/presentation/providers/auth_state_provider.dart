import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:playmax_app_1/presentation/providers/user_info_provider.dart';
part 'auth_state_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  //Supabase instance
  final supabase = Supabase.instance.client;

  @override
  //isLoggedIn (false by default)
  bool build() {
    return false;
  }

  //Try loggin method
  Future<String> tryLogin(
      {required String email, required String password}) async {
    try {
      AuthResponse res = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      String userUid = res.user!.id;

      //Retrieve the users public information to be used in public
      final userData = await supabase
          .from('users')
          .select('name, email, rol')
          .eq('uid_users', userUid)
          .single();

      //Store the user data in state manager
      ref.read(userInfoProvider.notifier).setUserInfo(userData);

      state = true;
      return 'loggedIn';
    } on AuthException catch (e) {
      state = false;
      return e.message;
    }
  }

  //Logout method
  Future<String> tryLogout() async {
    try {
      await supabase.auth.signOut();
      return 'loggedOut';
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Ocurrió un error inesperado!!';
    }
  }
}
