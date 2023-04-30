import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Seminar8(title: 'Семинар 8'),
    );
  }
}

class Seminar8 extends StatefulWidget {
  const Seminar8({super.key, required this.title});

  final String title;

  @override
  State<Seminar8> createState() => _Seminar8State();
}

class _Seminar8State extends State<Seminar8> {
  Duration duration = const Duration(seconds: 0);
  Timer? timer;
  String selected = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  void startTimer() {
    timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setState(() {
              duration = Duration(seconds: duration.inSeconds + 1);
            }));
  }

  void stopTimer({bool resets = true}) {
    setState(() => duration = const Duration(seconds: 0));
    setState(() {
      timer?.cancel();
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    setState(() {
      selected = 'date';
    });
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text =
            '${selectedDate.year}/${selectedDate.month}/${selectedDate.day}';
      });
      stopTimer();
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    setState(() {
      selected = 'time';
    });
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _timeController.text = '${selectedTime.hour}:${selectedTime.minute}';
      });
      stopTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(children: [
            Text('$hours:$minutes:$seconds'),
            const SizedBox(
              height: 4,
            ),
            TextButton(
                onPressed: () {
                  startTimer();
                },
                child: const Text("Start")),
            const SizedBox(
              height: 4,
            ),
            ListTile(
              title: const Text("Date"),
              leading: Radio(
                value: 'date',
                groupValue: selected,
                onChanged: (value) => {
                  if (value == 'date') {_selectDate(context)}
                },
              ),
            ),
            ListTile(
              title: const Text("Time"),
              leading: Radio(
                value: 'time',
                groupValue: selected,
                onChanged: (value) => {
                  if (value == 'time') {_selectTime(context)}
                },
              ),
            ),
            Row(
              children: [
                TextButton(
                    onPressed: () {},
                    child:
                        Text('${_dateController.text} ${_timeController.text}'))
              ],
            )
          ]),
        ));
  }
}
