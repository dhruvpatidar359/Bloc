import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

const names = ['Foo', "bar", "baz"];

extension RandomElement<T> on Iterable<T> {
  T getRandom() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() {
    emit(names.getRandom());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<String?>(
      stream: cubit.stream,
      builder: (context, snapshot) {
        final button = TextButton(
            onPressed: () => cubit.pickRandomName(),
            child: Text("the random name is "));

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return button;
          case ConnectionState.active:
            return Column(
              children: [button, Text(snapshot.data ?? "")],
            );
          case ConnectionState.done:
            return SizedBox();

          case ConnectionState.waiting:
            return button;

          default:
            return button;
            
        }
      },
    ));
  }
}
