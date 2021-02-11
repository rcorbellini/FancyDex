import 'dart:math';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:fancy_dex/core/utils/network_status.dart';
import 'package:fancy_dex/core/utils/sorted_cache_memory.dart';
import 'package:fancy_dex/data/data_sources/pokemon_cache_data_source.dart';
import 'package:fancy_dex/data/data_sources/pokemon_remote_data_source.dart';
import 'package:fancy_dex/data/entities/pokemon_entity.dart';
import 'package:fancy_dex/data/repositories/pokemon_repository_imp.dart';
import 'package:fancy_dex/domain/repositories/pokemon_repository.dart';
import 'package:fancy_dex/domain/use_cases/get_all_pokemon_use_case.dart';
import 'package:fancy_dex/domain/use_cases/get_pokemon_use_case.dart';
import 'package:fancy_dex/presentation/detail/bloc/detail_bloc.dart';
import 'package:fancy_dex/presentation/home/bloc/home_bloc.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:http/http.dart' as http;

///this file is temporary, just to use before apply some DI.class

///Blocs
HomeBloc get newInstanceHomeBloc =>
    HomeBloc(fancy: FancyImp(), getAllPokemonUseCase: newInstanceGetAllUseCase, getPokemonUseCase: newInstanceGetPokemonUseCase);
DetailBloc get newInstaceDetailBloc => DetailBloc(
    fancy: FancyImp(), getPokemonUseCase: newInstanceGetPokemonUseCase);

///Use Case
GetAllPokemonUseCase get newInstanceGetAllUseCase =>
    GetAllPokemonUseCase(newInstancePokemonRepository);
GetPokemonUseCase get newInstanceGetPokemonUseCase =>
    GetPokemonUseCase(newInstancePokemonRepository);

///Repository
PokemonRepository get newInstancePokemonRepository => PokemonRepositoryImp(
    networkStatus: NetworkStatusImp(DataConnectionChecker()),
    random: Random(),
    pokemonCacheDataSource:
        PokemonCacheDataSourceImp(SortedCacheMemory<PokemonEntity>()),
    pokemonRemoteDataSource:
        PokemonRemoteDataSourceImpl(client: http.Client()));
