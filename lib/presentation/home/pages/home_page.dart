import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_dex/core/utils/sorted_cache_memory.dart';
import 'package:fancy_dex/presentation/home/bloc/home_bloc.dart';
import 'package:fancy_dex/presentation/home/bloc/home_event.dart';
import 'package:fancy_dex/presentation/home/bloc/home_status.dart';
import 'package:fancy_dex/presentation/home/models/pokemon_presentation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final HomeBloc homeBloc;

  const HomePage({Key key, this.homeBloc}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc get _homeBloc => widget.homeBloc;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200;

  @override
  void initState() {
    _homeBloc.dispatchOn<HomeEvent>(LoadMorePokemons(),
        key: _homeBloc.eventKey);
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildFilterByName(),
        _buildMainContent(),
        _buildLoadMore(),
        _buildRandomPokemon(),
      ],
    );
  }

  Widget _buildRandomPokemon() {
    return RaisedButton(
        child: Text('Random'),
        onPressed: () => _homeBloc.dispatchOn<HomeEvent>(RandomPokemon(),
            key: _homeBloc.eventKey));
  }

  Widget _buildLoadMore() {
    return RaisedButton(
        child: Text('+'),
        onPressed: () => _homeBloc.dispatchOn<HomeEvent>(LoadMorePokemons(),
            key: _homeBloc.eventKey));
  }

  Widget _buildFilterByName() {
    return TextField();
  }

  Widget _buildMainContent() {
    return Expanded(
        child: StreamBuilder(
      initialData: ListLoading(),
      stream: _homeBloc.streamOf<HomeStatus>(key: _homeBloc.statusPokemonKey),
      builder: (context, snapshot) {
        final data = snapshot.data;

        if (data is ListLoading) {
          return _buildLoading();
        } else if (data is ListLoaded) {
          return _buildPokemonList(data.pokemons);
        }

        return _buildError();
      },
    ));
  }

  Widget _buildLoading() {
    return Text('Carregando');
  }

  Widget _buildError() {
    return Text('Erro aconteceu! tente novamente com internet.');
  }

  Widget _buildPokemonList(SortedCacheMemory<PokemonPresentation> pokemons) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _buildPokemonItem(pokemons.elementAt(index));
      },
      itemCount: pokemons.length,
      controller: _scrollController,
    );
  }

  Widget _buildPokemonItem(PokemonPresentation pokemon) {
    return Row(
      children: [
        CachedNetworkImage(
          imageUrl: pokemon.imageUrl,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          height: 100,
        ),
        Text(pokemon.name)
      ],
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _homeBloc.dispatchOn<HomeEvent>(LoadMorePokemons(),
          key: _homeBloc.eventKey);
    }
  }
}
