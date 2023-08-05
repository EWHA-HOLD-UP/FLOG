import 'package:flog/kakao_login.dart';
import 'package:flog/main_view_model.dart';
import 'package:flutter/material.dart';

class KakaoLoginScreen extends StatelessWidget {
  const KakaoLoginScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final viewModel = MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget> [
              Image.network(viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? ''),
              Text('${viewModel.isLogined}'),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF609966)
                ),
                  onPressed: () async {
                    await viewModel.login();
                    setState(() {});
                  },
                  child: const Text(
                    'Kakao Login',
                      style: TextStyle(color: Colors.white)
                  )
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF609966)
                  ),
                  onPressed: ()async {
                    await viewModel.logout();
                    setState(() {});
                  },
                  child: const Text('Kakao Logout',
                      style: TextStyle(color: Colors.white)
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

