import 'dart:math';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:fancy_dex/core/utils/network_status.dart';
import 'package:fancy_dex/core/utils/sorted_cache_memory.dart';
import 'package:fancy_dex/data/data_sources/pokemon_cache_data_source.dart';
import 'package:fancy_dex/data/data_sources/pokemon_remote_data_source.dart';
import 'package:fancy_dex/data/entities/pokemon_entity.dart';
import 'package:fancy_dex/data/repositories/pokemon_repository_imp.dart';
import 'package:fancy_dex/presentation/detail/bloc/detail_bloc.dart';
import 'package:fancy_dex/presentation/home/bloc/home_bloc.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:http/http.dart' as http;

///this file is temporary, just to use before apply some DI.class

get newInstanceHomeBloc => HomeBloc(
    fancy: FancyImp(), pokemonRepository: newInstancePokemonRepository);

get newInstaceDetailBloc =>
    DetailBloc(fancy: FancyImp(), pokemonRepository: newInstanceHomeBloc);

get newInstancePokemonRepository => PokemonRepositoryImp(
    networkStatus: NetworkStatusImp(DataConnectionChecker()),
    random: Random(),
    pokemonCacheDataSource:
        PokemonCacheDataSourceImp(SortedCacheMemory<PokemonEntity>()),
    pokemonRemoteDataSource:
        PokemonRemoteDataSourceImpl(client: http.Client()));
