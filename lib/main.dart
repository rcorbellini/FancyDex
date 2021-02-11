import 'dart:math';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:fancy_dex/core/utils/sorted_cache_memory.dart';
import 'package:fancy_dex/core/utils/network_status.dart';
import 'package:fancy_dex/data/data_sources/pokemon_cache_data_source.dart';
import 'package:fancy_dex/data/data_sources/pokemon_remote_data_source.dart';
import 'package:fancy_dex/data/entities/pokemon_entity.dart';
import 'package:fancy_dex/data/repositories/pokemon_repository_imp.dart';
import 'package:fancy_dex/factory.dart';
import 'package:fancy_dex/presentation/home/bloc/home_bloc.dart';
import 'package:fancy_dex/presentation/home/pages/home_page.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
