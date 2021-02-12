import 'package:fancy_dex/factory.dart';
import 'package:fancy_dex/features/pokedex/presentation/home/bloc/home_bloc.dart';
import 'package:fancy_dex/features/pokedex/presentation/home/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HomeBloc _bloc;
  @override
  void initState() {
    _bloc = newInstanceHomeBloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: HomePage(
        homeBloc: _bloc,
      ),
    ));
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }
}
