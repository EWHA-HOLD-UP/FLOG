import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Image.asset(
                  "assets/flog_logo.png",
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 70),
                ElevatedButton(
<<<<<<< Updated upstream
                  onPressed: () {},
=======
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KakaoLoginScreen(),
                      ),
                    );
                  },
>>>>>>> Stashed changes
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.white,
                    minimumSize: const Size(300, 50),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text(
                    '시작하기 - 카카오',
                    style: TextStyle(
                      color: Color(0xFF609966),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: const Color(0xFF609966),
                    minimumSize: const Size(300, 50), // 버튼의 최소 크기 설정 (가로 200, 세로 50)
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 내부 패딩 설정
                  ),
                  child: const Text(
                    '로그인 하기 (재로그인)',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }
}