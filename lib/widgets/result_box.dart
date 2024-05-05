import 'package:flutter/material.dart';
import '../constants.dart';

class ResultBox extends StatelessWidget {
  const ResultBox({super.key, required this.result, required this.questionLength, required this.onPressed});

  final int result;
  final int questionLength;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: background,
      content: Padding(
        padding: const EdgeInsets.all(70.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
                "Итог",
              style: TextStyle(
                  color: neutral,
                fontSize: 22.0
              ),
            ),
            const SizedBox(height: 20.0,),
            CircleAvatar(
              radius: 100.0,
              backgroundColor: result == questionLength / 2 ? Colors.amber : result < questionLength / 2 ? incorrect : correct,
              child: Text(
                "$result из $questionLength",
                style: const TextStyle(
                  fontSize: 30.0,
                  color: neutral,
                ),
              ),
            ),
            const SizedBox(height: 20.0,),
            Text(
              result == questionLength / 2 ? "Как-то средненько. Нужно немного подтянуть знание денег" : result < questionLength / 2 ? "Ужас! Срочно пройти курс по финансовой грамотности в Тинькофф Журнале!!!" : "Отлично! Не пропадёшь в этом мире.",
              style: const TextStyle(color: neutral),
            ),
            const SizedBox(height: 25.0,),
            GestureDetector(
              onTap: onPressed,
              child: const Text(
                  "Начать заново",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  letterSpacing: 1.0,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
