import 'package:flutter/material.dart';
import 'package:untitled/widgets/result_box.dart';
import '../constants.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Question> _questions = [
    Question(
        id: '10',
        title: 'Что такое акция?',
        options: {
          'Часть бизнеса компании, которую можно купить': true,
          'Долговая расписка компании': false,
          'Фантики': false
        }
    ),
    Question(
        id: '20',
        title: 'Что такое облигация?',
        options: {
          'Часть бизнеса компании': false,
          'Долговая расписка компании, обязующая компанию вернуть деньги с процентами': true,
        }
    ),
    Question(
        id: '30',
        title: 'Отличие накопительного счёта от вклада',
        options: {
          'Вклад открывается на определённый срок, а накопительный счёт бессрочен': true,
          'На вкладах есть сложный процент': false,
          'Отличий больно нет никаких': false,
        }
    )
  ];

  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;

  void nextQuestion() {
    if(index == _questions.length - 1){
      showDialog
        (context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
            result: score,
            questionLength: _questions.length,
            onPressed: startOver,
      ));
    }
    else{
      if(isPressed){
        setState(() {
          index++;
          isPressed = false;
          isAlreadySelected = false;
        });
      } else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Пожалуйста, ответьте на вопрос"),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20.0),
          )
        );
      }
    }
  }

  void checkAnswerAndUpdate(bool value){
    if(isAlreadySelected){
      return;
    }
    else{
      if(value == true){
        score++;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }

  void startOver(){
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text("Финансовый грамотей"),
        backgroundColor: background,
        shadowColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
                "Счёт: $score",
              style: const TextStyle(fontSize: 18.0), // TODO
            ),
          )
        ]
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
           children: [
             QuestionWidget(
                 question: _questions[index].title,
                 indexActoin: index ,
                 totalQuestions: _questions.length
             ),
             const Divider(color: neutral),
             const SizedBox(height: 25.0),
             for(int i = 0; i < _questions[index].options.length; i++)
               GestureDetector(
                 onTap: () => checkAnswerAndUpdate(_questions[index].options.values.toList()[i]),
                 child: OptionCard(
                     option: _questions[index].options.keys.toList()[i],
                   color: isPressed ? _questions[index].options.values.toList()[i] == true ?
                   correct: incorrect : neutral,
                 ),
               ),
           ],
        ),
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: NextButton(
          nextQuestion: nextQuestion,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
