import 'package:flutter/material.dart';

class TodayStockWidget extends StatelessWidget {
  final String kospiTitle;
  final String kospiValue;
  final String kosdaqTitle;
  final String kosdaqValue;

  const TodayStockWidget({
    super.key,
    required this.kospiTitle,
    required this.kospiValue,
    required this.kosdaqTitle,
    required this.kosdaqValue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff45526C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 90,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildInfoRow('KOSPI', kospiValue),
            const SizedBox(height: 10),
            _buildInfoRow('KOSDAQ', kosdaqValue),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          ":",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "$value p",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
