import 'dart:convert';

import 'package:fancy_dex/core/errors.dart';
import 'package:fancy_dex/core/exceptions.dart';
import 'package:fancy_dex/data/entities/pokemon_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

abstract class PokemonRemoteDataSource {
  Future<PokemonEntity> getPokemonById(int name);

  Future<PokemonEntity> getPokemonByName(String name);

  Future<List<PokemonEntity>> getAllPaged({int offset = 0, int limit = 20});
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final http.Client client;

  PokemonRemoteDataSourceImpl({@required this.client});

  @override
  Future<PokemonEntity> getPokemonById(int id) =>
      _getOne('https://pokeapi.co/api/v2/pokemon/$id');

  @override
  Future<PokemonEntity> getPokemonByName(String name) =>
      _getOne('https://pokeapi.co/api/v2/pokemon/$name');

  @override
  Future<List<PokemonEntity>> getAllPaged({int offset = 0, int limit = 20}) =>
      _getAll('https://pokeapi.co/api/v2/pokemon/?offset=$offset&limit=$limit');

  Future<List<PokemonEntity>> _getAll(url) async {
    final response =
        await client.get(url, headers: {'content-type': 'application/json'});

    if (response.statusCode == 200) {
      final result = json.decode(response.body)['results'] as Iterable;

      return result.map((item) => PokemonEntity.fromJson(item)).toList();
    } else {
      throw RemoteException();
    }
  }

  Future<PokemonEntity> _getOne(url) async {
    final response =
        await client.get(url, headers: {'content-type': 'application/json'});

    if (response.statusCode == 200) {
      return PokemonEntity.fromJson(json.decode(response.body));
    } else {
      throw RemoteException();
    }
  }
}
