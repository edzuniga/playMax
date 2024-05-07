import 'package:playmax_app_1/presentation/providers/active_page_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  //Check auth status
  Future<int> chechAuthStatus() async {
    //1 = AUTHENTICATED
    //2 = NOT AUTHENTICATED
    final supabase = Supabase.instance.client;
    final session = supabase.auth.currentSession;

    if (session != null) {
      state = true;
      return 1;
    } else {
      state = false;
      return 2;
    }
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

      //Store retrieved data in sharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', userData['name']);
      await prefs.setString('email', userData['email']);
      await prefs.setInt('rol', userData['rol']);

      state = true;
      return 'loggedIn';
    } on AuthException catch (e) {
      state = false;
      return e.message;
    }
  }

  //Logout method
  Future<String> tryLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await supabase.auth.signOut(); //logout
      await prefs.clear(); //clear stored data
      state = false;
      ref.read(activePageProvider.notifier).setPageIndex(0);
      return 'loggedOut';
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'Ocurrió un error inesperado!!';
    }
  }
}
