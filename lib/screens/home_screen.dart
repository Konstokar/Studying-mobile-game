import 'package:flutter/material.dart';
import 'package:untitled/widgets/result_box.dart';
import '../constants.dart';
import '../models/question_model.dart';
import '../widgets/question_widget.dart';
import '../widgets/next_button.dart';
import '../widgets/option_card.dart';
import '../models/db_connect.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var db = DBconnect();
  /*List<Question> _questions = [
    Question(
        id: '1',
        title: 'Что такое акция?',
        options: {
          'Часть бизнеса компании, которую можно купить': true,
          'Долговая расписка компании': false,
          'Фантики': false
        }
    ),
    Question(
        id: '2',
        title: 'Что такое облигация?',
        options: {
          'Часть бизнеса компании': false,
          'Долговая расписка компании, обязующая компанию вернуть деньги с процентами': true,
        }
    ),
    Question(
        id: '3',
        title: 'Отличие накопительного счёта от вклада',
        options: {
          'Вклад открывается на определённый срок, а накопительный счёт бессрочен': true,
          'На вкладах есть сложный процент': false,
          'Отличий больно нет никаких': false,
        }
    )
  ];*/
  late Future _questions;

  Future<List<Question>> getData() async{
    return db.fetchQuestion();
  }

  @override
  void initState() {
    _questions = getData();
    super.initState();
  }

  int index = 0;
  int score = 0;
  bool isPressed = false;
  bool isAlreadySelected = false;

  void nextQuestion(int questionLength) {
    if(index == questionLength - 1){
      showDialog
        (context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
            result: score,
            questionLength: questionLength,
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
    return FutureBuilder(
      future: _questions as Future<List<Question>>,
      builder: (ctx, snapshot) {
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return Center(child: Text("${snapshot.error}"),);
          }
          else if(snapshot.hasData){
            var extractedData = snapshot.data as List<Question>;
            return Scaffold(
              backgroundColor: background,
              appBar: AppBar(
                  title: const Text(
                      "Финансовый грамотей",
                    style: TextStyle(
                      color: neutral
                    ),
                  ),
                  backgroundColor: background,
                  shadowColor: Colors.transparent,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(
                        "Счёт: $score",
                        style: const TextStyle(
                            fontSize: 18.0,
                          color: neutral
                        ),
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
                        question: extractedData[index].title,
                        indexActoin: index ,
                        totalQuestions: extractedData.length
                    ),
                    const Divider(color: neutral),
                    const SizedBox(height: 25.0),
                    for(int i = 0; i < extractedData[index].options.length; i++)
                      GestureDetector(
                        onTap: () => checkAnswerAndUpdate(extractedData[index].options.values.toList()[i]),
                        child: OptionCard(
                          option: extractedData[index].options.keys.toList()[i],
                          color: isPressed ? extractedData[index].options.values.toList()[i] == true ?
                          correct: incorrect : neutral,
                        ),
                      ),
                  ],
                ),
              ),

              floatingActionButton: GestureDetector(
                onTap: () => nextQuestion(extractedData.length),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: NextButton(
                  ),
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            );
          }
          else{
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                   const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                      "Загрузка...",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.none,
                        fontSize: 14.0,
                      ),
                  ),
                ],
              ),
            );
          }
        }
        return const Center(child: Text("Нет данных"),);
      },
    );
  }
}
