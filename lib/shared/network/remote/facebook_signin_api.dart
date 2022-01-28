import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookSignInApi {

  static Future<LoginResult> login () => FacebookAuth.i.login();

  static Future<void> logout () => FacebookAuth.i.logOut();
}