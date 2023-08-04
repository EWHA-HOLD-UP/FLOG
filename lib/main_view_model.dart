import 'package:firebase_auth/firebase_auth.dart';
import 'package:flog/firebase_auth_remote_data_source.dart';
import 'package:flog/social_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class MainViewModel {
  final _firebaseAuthDataSource = FirebaseAuthRemoteDataSource();
  final SocialLogin _socialLogin;
  bool isLogined = false;
  String state = "로그아웃되었습니다";
  kakao.User? user;

  MainViewModel(this._socialLogin);

  Future login() async {
    isLogined = await _socialLogin.login();
    if (isLogined) {
      user = await kakao.UserApi.instance.me();
      state = "로그인되었습니다.";

      final token = await _firebaseAuthDataSource.createCustomToken({
        'uid': user!.id.toString(),
        'displayName': user!.kakaoAccount!.profile!.nickname,
        'email': user!.kakaoAccount!.email!,
        'photoURL': user!.kakaoAccount!.profile!.profileImageUrl!,
      });

      await FirebaseAuth.instance.signInWithCustomToken(token);
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    isLogined = false;
    user = null;
    state = "로그아웃되었습니다";
  }
}
