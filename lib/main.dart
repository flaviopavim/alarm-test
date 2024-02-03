import 'package:alarmtest/widget/Button.dart';
import 'package:alarmtest/widget/Input.dart';
import 'package:alarmtest/widget/Select.dart';
import 'package:flutter/material.dart';

import 'fn/sql.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String frequency_value = "";
  String duration_value = "";

  TextEditingController controller_frequency_period = TextEditingController();
  TextEditingController controller_duration_period = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        //padding: EdgeInsets.all(8.0),
          itemCount: 1,
          itemBuilder: (context, i) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Selecione a frequência'),

                  Row(
                    children: [
                      Expanded(child: Text('à cada')),
                      Expanded(child: Input(
                          text: 'x', controller: controller_frequency_period)),
                      Expanded(child: Select(text: 'Horas',
                          options: [
                            {
                              'name': '',
                              'title': 'Select'
                            },
                            {
                              'name': 'hour',
                              'title': 'Horas'
                            },
                            {
                              'name': 'day',
                              'title': 'Dias'
                            },
                            {
                              'name': 'week',
                              'title': 'Semanas'
                            },
                            {
                              'name': 'month',
                              'title': 'Meses'
                            }
                          ],
                          selected: frequency_value,
                          onChanged: (String? newValue) {
                            frequency_value = newValue.toString();
                            setState(() {

                            });
                          })),
                    ],
                  ),

                  const Text('Selecione a duração'),

                  Row(
                    children: [
                      Expanded(child: Text('à cada')),
                      Expanded(child: Input(
                          text: 'x', controller: controller_duration_period)),
                      Expanded(child: Select(text: 'Horas',
                          options: [
                            {
                              'name': '',
                              'title': 'Select'
                            },
                            {
                              'name': 'hour',
                              'title': 'Horas'
                            },
                            {
                              'name': 'day',
                              'title': 'Dias'
                            },
                            {
                              'name': 'week',
                              'title': 'Semanas'
                            },
                            {
                              'name': 'month',
                              'title': 'Meses'
                            }
                          ],
                          selected: frequency_value,
                          onChanged: (String? newValue) {
                            frequency_value = newValue.toString();
                            setState(() {

                            });
                          })),
                    ],
                  ),

                  GestureDetector(
                      onTap: () async {
                        await sql("INSERT INTO calendar ("
                            "frequency_period, "
                            "frequency_value, "
                            "duration_period, "
                            "duration_value"
                            ") VALUES ( "
                            "'${controller_frequency_period.text}', "
                            "'${frequency_value}', "
                            "'${controller_duration_period.text}', "
                            "'${duration_value}'"
                            ")");
                      },
                      child: Button(text: 'Salvar', color: Colors.blue)
                  ),


                ],
              ),
            );
          }),
    );
  }
}