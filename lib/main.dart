import 'package:flutter/material.dart';
import 'package:untitled/models/question_model.dart';
import 'package:untitled/screens/home_screen.dart';
import './models/db_connect.dart';

void main(){
  var db = DBconnect();
  db.addQuestion(
    Question(
        id: '12',
        title: 'Где из перечисленных ниже вариантов лучше всего хранить свои деньги?',
        options: {
          'На накопительном счёте / вкладе в банке': true,
          'Под подушкой': false,
          'У соседа': false,
          'В закопанном сундуке': false,
        }
    )
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
