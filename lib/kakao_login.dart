import 'package:flog/social_login.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoLogin implements SocialLogin {
  @override
  Future<bool> login() async {
    try {
      bool isInatalled = await isKakaoTalkInstalled();
      if (isInatalled) {
        // 카카오톡 설치된 경우
        try {
          await UserApi.instance.loginWithKakaoTalk();
          return true;
        } catch (e) {
          return false;
        }
      } else {
        // 카카오톡 설치 안된 경우
        try {
          await UserApi.instance.loginWithKakaoAccount();
          return true;
        } catch (e) {
          return false;
        }
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (e) {
      return false;
    }
  }
}
