import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:your_finance/model/keystatisticlist_model.dart';
import 'package:your_finance/screen/dict_screen.dart';
import 'package:your_finance/screen/setting_screen.dart';
import 'package:your_finance/service/bok_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _FinanceHomePageState();
}

class _FinanceHomePageState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreenContent(),
    const DictionaryScreen(),
    const SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
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

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  String _getFormattedDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy년 MM월 dd일 EEEE', 'ko');
    return formatter.format(now);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<KeyStatisticListModel>>(
        future: BokApiService().getKeyStatisticList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('데이터를 불러오는데 실패했습니다'));
          } else if (snapshot.hasData) {
            final exchangeRates = snapshot.data!
                .where((stat) => [
                      '원/달러 환율(종가)',
                      '원/엔(100엔) 환율(매매기준율)',
                      '원/유로 환율(매매기준율)',
                      '원/위안 환율(종가)'
                    ].contains(stat.keystatName))
                .toList();

            final kospiStat = snapshot.data!.firstWhere(
              (stat) => stat.keystatName == "코스피지수",
            );
            final kosdaqStat = snapshot.data!.firstWhere(
              (stat) => stat.keystatName == "코스닥지수",
            );

            return CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  floating: true,
                  backgroundColor: Colors.grey[50],
                  elevation: 0,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Finance',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff5AA897),
                        ),
                      ),
                      Text(
                        _getFormattedDate(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Content
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Exchange Rates Section
                      const Row(
                        children: [
                          Icon(
                            Icons.currency_exchange,
                            color: Color(0xff5AA897),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '환율 정보',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 items per row
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio:
                              1.8, // Adjust the height to make it look balanced
                        ),
                        itemCount: exchangeRates.length,
                        itemBuilder: (context, index) {
                          final rate = exchangeRates[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xff45526C),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  rate.keystatName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  "${rate.dataValue}${rate.unitName}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Market Overview Section
                      const Row(
                        children: [
                          Icon(
                            Icons.show_chart,
                            color: Color(0xff5AA897),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '증시 현황',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMarketCard(
                              'KOSPI',
                              kospiStat.dataValue,
                              true,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMarketCard(
                              'KOSDAQ',
                              kosdaqStat.dataValue,
                              false,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Interest Rates Section
                      const Row(
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            color: Color(0xff5AA897),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '금리 정보',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xff45526C),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _buildInterestRateRow(
                              '한국은행 기준금리',
                              snapshot.data!
                                  .firstWhere(
                                    (stat) => stat.keystatName == "한국은행 기준금리",
                                  )
                                  .dataValue,
                            ),
                            const Divider(color: Colors.white24),
                            _buildInterestRateRow(
                              '국고채수익률(3년)',
                              snapshot.data!
                                  .firstWhere(
                                    (stat) => stat.keystatName == "국고채수익률(3년)",
                                  )
                                  .dataValue,
                            ),
                            const Divider(color: Colors.white24),
                            _buildInterestRateRow(
                              '국고채수익률(5년)',
                              snapshot.data!
                                  .firstWhere(
                                    (stat) => stat.keystatName == "국고채수익률(5년)",
                                  )
                                  .dataValue,
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('데이터가 없습니다'));
          }
        },
      ),
    );
  }

  Widget _buildMarketCard(String title, String value, bool isKospi) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff45526C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.show_chart,
                color: isKospi ? Colors.blue[300] : Colors.orange[300],
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestRateRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          Text(
            '$value%',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
