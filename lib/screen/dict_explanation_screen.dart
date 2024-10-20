import 'package:flutter/material.dart';

class ExplanationScreen extends StatelessWidget {
  final String word;
  final String content;

  const ExplanationScreen({
    super.key,
    required this.word,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F5F1),
      appBar: AppBar(
        title: Text(
          word,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xffF8F5F1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 17, color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
