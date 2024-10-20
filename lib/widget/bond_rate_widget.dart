import 'package:flutter/material.dart';

class BondRateWidget extends StatelessWidget {
  final String interestRate;
  final String bondYield3Y;
  final String bondYield5Y;
  final String loanYield;

  const BondRateWidget({
    super.key,
    required this.interestRate,
    required this.bondYield3Y,
    required this.bondYield5Y,
    required this.loanYield,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff45526C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        margin: const EdgeInsets.all(15),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('한국은행 기준금리', "$interestRate%"),
            const SizedBox(height: 2),
            _buildInfoRow('국고채수익률 (3년)', "$bondYield3Y%"),
            const SizedBox(height: 2),
            _buildInfoRow('국고채수익률 (5년)', "$bondYield5Y%"),
            const SizedBox(height: 2),
            _buildInfoRow('예금은행 대출금리', "$loanYield%"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
