import 'package:flutter/material.dart';
import 'package:untitled/constants.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({super.key, required this.question, required this.indexActoin, required this.totalQuestions});

  final String question;
  final int indexActoin;
  final int totalQuestions;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
          "Вопрос ${indexActoin + 1} из $totalQuestions: $question",
        style: TextStyle(
          fontSize: 24.0,
           color: neutral
        ),
      ),
    );
  }
}
