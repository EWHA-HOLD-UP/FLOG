import 'package:flog/kakao_login.dart';
import 'package:flog/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class KakaoLoginScreen extends StatelessWidget {
  const KakaoLoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return ElevatedButton(
                        onPressed: () async {
                          await viewModel.login();
                          setState(() {});
                        },
                        child: const Text('Login'));
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.network(viewModel
                              .user?.kakaoAccount?.profile?.profileImageUrl ??
                          ''),
                      Text('${viewModel.isLogined}'),
                      Text(viewModel.state),
                      ElevatedButton(
                          onPressed: () async {
                            await viewModel.logout();
                            setState(() {});
                          },
                          child: const Text('Logout'))
                    ],
                  );
                })),
      ),
    );
  }
}
