import 'dart:math';

import 'package:chat_group_list/chat_group_list.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Random random = Random();
  var faker = Faker();
  final ScrollController _scrollController = ScrollController();

  List<MessageItemDto> messages=[
    MessageItemDto(
        message: 'Мое сообщеение 2',
        date: DateTime.now(),
        isMine: true
    ),
    MessageItemDto(
      message: 'Мое сообщеение 1',
      date: DateTime(2024, 7, 1),
    ),
    MessageItemDto(
      message: 'Мое сообщеение 1',
      date: DateTime(2024, 7, 1),
    ),
    MessageItemDto(
        message: 'Мое сообщеение 1',
        date: DateTime(2024, 7, 1)
    ),
    MessageItemDto(
        message: 'Мое сообщеение 2',
        date: DateTime(2024, 7, 2)
    ),
    MessageItemDto(
        message: 'Мое сообщеение 2',
        date: DateTime(2024, 7, 2),
        isMine: true

    ),
    MessageItemDto(
        message: 'Мое сообщеение 2',
        date: DateTime(2024, 7, 2),
        isMine: true

    ),
    MessageItemDto(
        message: 'Мое сообщеение 2',
        date: DateTime(2024, 7, 2),
        isMine: true

    ),
    MessageItemDto(
        message: 'Мое сообщеение 2',
        date: DateTime(2024, 7, 2),
        isMine: true

    ),
    MessageItemDto(
        message: 'Мое сообщеение 3',
        date: DateTime(2024, 7, 3),
        isMine: true

    ),
    MessageItemDto(
        message:
        'Мое сообщеение 3 очень длинное сообщение я очень хочу проверить как оно отображается в чате',
        date: DateTime(2024, 7, 3),
        isMine: true
    ),
  ];

  void _incrementCounter() {
    messages.add(MessageItemDto(
        message: faker.lorem.sentence(),
        date: DateTime.now(),
        isMine: random.nextBool()
    ));
    setState(() {

    });
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ChatGroupList<MessageItemDto>(
        items: messages,
        contentBuilder: (_,MessageItemDto item)=>Container(
          child: Text(item.message),
        ),
        dataSeparatorBuilder: (_,DateTime date)=>Container(
          alignment: Alignment.center,
          child: Text(DateFormat('d MMMM').format(date)),
        ),
        messageInformationBuilder: (_,MessageItemDto item)=>Container(
          child: Text(DateFormat('HH:mm').format(item.date),
          ),
        ),
        primaryRadius: 24,
        secondaryRadius: 3,
        mineBackgroundColor: Colors.red,
        controller: _scrollController,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class MessageItemDto extends MessageItem{
  MessageItemDto({required super.message, required super.date, super.isMine = false});


}
