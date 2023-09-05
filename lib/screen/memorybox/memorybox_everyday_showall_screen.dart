import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'memorybox_detail_screen.dart';

class MemoryBoxEverydayShowAllScreen extends StatelessWidget {
  const MemoryBoxEverydayShowAllScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell( //close 아이콘 버튼
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset(
              "button/back_arrow.png",
              width: 20,
              height: 20
          ),
        ),
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            SizedBox(width: 110),
            Text('모든날',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        elevation: 0.0, //그림자 없음
        centerTitle: true,
      ),
      body: const Center(
        child: SafeArea(
          child: Column(
              children: [
                SizedBox(height: 25), //간격
                MemoryBoxInfiniteCalendar(),
              ]
          ),
        ),
      ),
    );
  }
}

class MemoryBoxInfiniteCalendar extends StatefulWidget {
  const MemoryBoxInfiniteCalendar({Key? key}) : super(key: key);

  @override
  MemoryBoxInfiniteCalendarState createState() => MemoryBoxInfiniteCalendarState();
}

class MemoryBoxInfiniteCalendarState extends State<MemoryBoxInfiniteCalendar> {
  late PageController _pageController;
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _pageController = PageController(initialPage: 100); //100개월(=8년 4개월정도..)까지 저장 가능
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentDate = DateTime.now().add(Duration(days: (page - 99) * 30));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: _onPageChanged, //페이지가 변경될 때 호출
        itemCount: 100,
        itemBuilder: (BuildContext context, int page) {
          final currentDate = DateTime(_currentDate.year, _currentDate.month, _currentDate.day);
          return _buildMonthCalendar(currentDate.year, currentDate.month);
        },
      ),
    );
  }

  Widget _buildMonthCalendar(int year, int month) {
    final lastDayOfMonth = DateTime(year, month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    int today = DateTime.now().day;

    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          DateFormat('yyyy.MM').format(DateTime(year, month)),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            SizedBox(width: 32),
            Text("일"),
            SizedBox(width: 5),
            Text("월"),
            SizedBox(width: 5),
            Text("화"),
            SizedBox(width: 5),
            Text("수"),
            SizedBox(width: 5),
            Text("목"),
            SizedBox(width: 5),
            Text("금"),
            SizedBox(width: 5),
            Text("토"),
            SizedBox(width: 33)
          ],
        ),
        _buildGrid(year, month, daysInMonth, today),
      ],
    );
  }

  Widget _buildGrid(int year, int month, int daysInMonth, int today) {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    return Container(
      height: 350,
      width: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 10.0,
        ),
        itemCount: daysInMonth,
        itemBuilder: (BuildContext context, int index) {
          final containerNumber = index + 1;
          final day = containerNumber.toString().padLeft(2, '0');
          final formattedMonth = month.toString().padLeft(2, '0');
          final formattedDate = '$year.$formattedMonth.$day';

          if ((year == currentYear && month == currentMonth && containerNumber > today) ||
              (year == currentYear && month > currentMonth) || (year > currentYear)) { //현재 월 이후의 날짜인 경우 회색에 숫자만 적힌 빈 컨테이너
            return GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFCED3CE),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  containerNumber.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          } else { //현재 월 이전 또는 현재 월의 오늘 이전인 경우 플로깅 이미지로 채워진 컨테이너
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        MemoryBoxDetailScreen(
                          selectedDate: formattedDate,
                        ),
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFFCED3CE),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: ClipRRect(
                        child: Image.asset(
                          "assets/emoticons/emoticon_$containerNumber.png",
                          width: 35,
                          height: 35,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        containerNumber.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

