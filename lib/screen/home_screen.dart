import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:your_finance/model/keystatisticlist_model.dart';
import 'package:your_finance/screen/dict_screen.dart';
import 'package:your_finance/screen/setting_screen.dart';
import 'package:your_finance/service/bok_api.dart';
import 'package:your_finance/widget/bond_rate_widget.dart';
import 'package:your_finance/widget/exchange_rate_widget.dart';
import 'package:your_finance/widget/population_statistics_widget.dart';
import 'package:your_finance/widget/today_stock_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _FinanceHomePageState();
}

class _FinanceHomePageState extends State<HomeScreen> {
  int _currentIndex = 0; // 현재 선택된 탭 인덱스

  // 각 탭에서 표시할 화면
  final List<Widget> _screens = [
    const HomeScreenContent(), // 홈 화면 콘텐츠
    const DictionaryScreen(), // 경제 용어 사전 화면
    const SettingScreen(), // 설정 화면
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F1),
      body: _screens[_currentIndex], // 선택된 화면 표시
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xffF8F5F1),
        selectedItemColor: const Color(0xff5AA897),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '경제용어사전',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }
}

// 홈 화면의 콘텐츠를 분리한 위젯
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  // 현재 날짜와 요일을 가져오기 위한 함수
  String _getFormattedDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter =
        DateFormat('yyyy-MM-dd EEEE 기준', 'ko'); // yyyy-MM-dd 형식과 요일 표시
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Finance",
                    style: TextStyle(
                      color: Color(0xff5AA897),
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                  const Spacer(),
                  // 오늘의 날짜와 요일 표시
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        _getFormattedDate(),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              FutureBuilder<List<KeyStatisticListModel>>(
                future: BokApiService().getKeyStatisticList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('Failed to load data');
                  } else if (snapshot.hasData) {
                    // 데이터를 필터링
                    final keyStats = snapshot.data!
                        .where((stat) =>
                            [
                              '원/달러 환율(종가)',
                              '원/엔(100엔) 환율(매매기준율)',
                              '원/유로 환율(매매기준율)',
                              '원/위안 환율(종가)',
                              '코스피지수',
                              '코스닥지수'
                            ].contains(stat.keystatName) &&
                            stat.keystatName != "코스피지수" &&
                            stat.keystatName != "코스닥지수")
                        .toList();

                    final kospiStat = snapshot.data!.firstWhere(
                      (stat) => stat.keystatName == "코스피지수",
                    );
                    final kosdaqStat = snapshot.data!.firstWhere(
                      (stat) => stat.keystatName == "코스닥지수",
                    );

                    final interestRate = snapshot.data!
                        .firstWhere(
                          (stat) => stat.keystatName == "한국은행 기준금리",
                        )
                        .dataValue;

                    final bondYield3Y = snapshot.data!
                        .firstWhere(
                          (stat) => stat.keystatName == "국고채수익률(3년)",
                        )
                        .dataValue;

                    final bondYield5Y = snapshot.data!
                        .firstWhere(
                          (stat) => stat.keystatName == "국고채수익률(5년)",
                        )
                        .dataValue;

                    final corporateBondYield = snapshot.data!
                        .firstWhere(
                          (stat) => stat.keystatName == "예금은행 대출금리",
                        )
                        .dataValue;

                    final unemploymentRate = snapshot.data!
                        .firstWhere(
                          (stat) => stat.keystatName == "실업률",
                        )
                        .dataValue;

                    final employmentRate = snapshot.data!
                        .firstWhere(
                          (stat) => stat.keystatName == "고용률",
                        )
                        .dataValue;

                    final elderlyPopulationRatio = snapshot.data!
                        .firstWhere(
                          (stat) => stat.keystatName == "고령인구비율",
                        )
                        .dataValue;

                    final fertilityRate = snapshot.data!
                        .firstWhere(
                          (stat) => stat.keystatName == "합계출산율",
                        )
                        .dataValue;

                    return Column(
                      children: [
                        SizedBox(
                          height: 90,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: keyStats.map((stat) {
                                return ExchangeRateWidget(
                                  title: stat.keystatName,
                                  value: "${stat.dataValue}${stat.unitName}",
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const Divider(
                          color: Color(0xff424242),
                          height: 30,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 30),
                            Text(
                              "오늘의 증시",
                              style: TextStyle(
                                color: Color(0xff5AA897),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.candlestick_chart_outlined,
                              size: 35,
                              color: Color(0xff5AA897),
                            ),
                          ],
                        ),
                        TodayStockWidget(
                          kospiTitle: kospiStat.keystatName,
                          kospiValue: kospiStat.dataValue,
                          kosdaqTitle: kosdaqStat.keystatName,
                          kosdaqValue: kosdaqStat.dataValue,
                        ),
                        const SizedBox(height: 5),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 30),
                            Text(
                              "주요 시장 금리",
                              style: TextStyle(
                                color: Color(0xff5AA897),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.stacked_bar_chart_outlined,
                              size: 35,
                              color: Color(0xff5AA897),
                            ),
                          ],
                        ),
                        BondRateWidget(
                          interestRate: interestRate,
                          bondYield3Y: bondYield3Y,
                          bondYield5Y: bondYield5Y,
                          loanYield: corporateBondYield,
                        ),
                        const SizedBox(height: 5),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(width: 30),
                            Text(
                              "주요 경제, 인구 통계",
                              style: TextStyle(
                                color: Color(0xff5AA897),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5),
                            Icon(
                              Icons.pie_chart_rounded,
                              size: 35,
                              color: Color(0xff5AA897),
                            ),
                          ],
                        ),
                        PopulationStatisticsWidget(
                          unemploymentRate: unemploymentRate,
                          employmentRate: employmentRate,
                          elderlyPopulationRatio: elderlyPopulationRatio,
                          fertilityRate: fertilityRate,
                        ),
                      ],
                    );
                  } else {
                    return const Text('No data available');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
