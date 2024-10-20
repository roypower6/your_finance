import 'package:flutter/material.dart';

class PopulationStatisticsWidget extends StatelessWidget {
  final String unemploymentRate;
  final String employmentRate;
  final String elderlyPopulationRatio;
  final String fertilityRate;

  const PopulationStatisticsWidget({
    super.key,
    required this.unemploymentRate,
    required this.employmentRate,
    required this.elderlyPopulationRatio,
    required this.fertilityRate,
  });

  // 반복되는 Row를 처리하는 함수
  Widget _buildStatisticRow(
    String title,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff45526C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatisticRow("실업률", "$unemploymentRate%"),
            const SizedBox(height: 2),
            _buildStatisticRow("고용률", "$employmentRate%"),
            const SizedBox(height: 2),
            _buildStatisticRow("고령인구비율", "$elderlyPopulationRatio%"),
            const SizedBox(height: 2),
            _buildStatisticRow("합계출산율", "$fertilityRate명"),
          ],
        ),
      ),
    );
  }
}
