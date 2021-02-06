import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:fancy_dex/core/utils/network_status.dart';
import 'package:fancy_dex/core/utils/sorted_cache_memory.dart';
import 'package:fancy_dex/data/data_sources/pokemon_cache_data_source.dart';
import 'package:fancy_dex/data/data_sources/pokemon_remote_data_source.dart';
import 'package:fancy_dex/data/entities/pokemon_entity.dart';
import 'package:fancy_dex/data/repositories/pokemon_repository_imp.dart';
import 'package:fancy_dex/presentation/detail/bloc/detail_bloc.dart';
import 'package:fancy_dex/presentation/detail/pages/detail_page.dart';
import 'package:fancy_dex/presentation/models/pokemon_presentation.dart';
import 'package:fancy_dex/presentation/widgets/poke_loading.dart';
import 'package:fancy_dex/presentation/widgets/poke_types.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fancy_dex/presentation/home/bloc/home_bloc.dart';
import 'package:fancy_dex/presentation/home/bloc/home_event.dart';
import 'package:fancy_dex/presentation/home/bloc/home_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    dispatchLoadingInitalPokemons();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void dispatchLoadingInitalPokemons() {
    _homeBloc.dispatchOn<HomeEvent>(LoadMorePokemons(),
        key: _homeBloc.eventKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Text("FancyDex",
            style: GoogleFonts.bellota(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.red.withOpacity(0.6),
            )),
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.filter_list,
                color: Colors.blueGrey,
              ),
              onPressed: () {})
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _buildRandomPokemon(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          //_buildFilterByName(),
          _buildMainContent(),
        ],
      ),
    );
  }

  Widget _buildRandomPokemon() {
    return FloatingActionButton(
        backgroundColor: Colors.blueGrey.shade400,
        child: Text(
          '?',
          style: GoogleFonts.lato(color: Colors.white, fontSize: 40),
        ),
        onPressed: () => _homeBloc.dispatchOn<HomeEvent>(RandomPokemon(),
            key: _homeBloc.eventKey));
  }

  Widget _buildFilterByName() {
    return Padding(
      padding: EdgeInsets.all(4),
      child: TextField(),
    );
  }

  Widget _buildMainContent() {
    return Expanded(
        child: StreamBuilder(
      initialData: ListLoading(),
      stream: _homeBloc.streamOf<HomeStatus>(key: _homeBloc.statusKey),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final pokemons = data.pokemonsLoaded;
        final loading = data is ListLoading;

        if (data is ListError) {
          return _buildError();
        }

        return Stack(
          children: [
            _buildPokemonList(pokemons),
            _buildLoading(loading),
          ],
        );
      },
    ));
  }

  Widget _buildLoading(bool loading) {
    if (loading) {
      return Positioned.fill(
        bottom: 30,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: PokeLoading(),
        ),
      );
    }

    return Container();
  }

  Widget _buildError() {
    return Text('Erro aconteceu! tente novamente com internet.');
  }

  Widget _buildPokemonList(List<PokemonPresentation> pokemons) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _buildPokemonItem(pokemons.elementAt(index));
      },
      itemCount: pokemons.length,
      controller: _scrollController,
    );
  }

  Widget _buildPokemonItem(PokemonPresentation pokemon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              id: pokemon.id,
              detailBloc: DetailBloc(
                fancy: FancyImp(),
                pokemonRepository: PokemonRepositoryImp(
                    networkStatus: NetworkStatusImp(DataConnectionChecker()),
                    random: Random(),
                    pokemonCacheDataSource: PokemonCacheDataSourceImp(
                        SortedCacheMemory<PokemonEntity>()),
                    pokemonRemoteDataSource:
                        PokemonRemoteDataSourceImpl(client: http.Client())),
              ),
            ),
          ),
        );
      },
      child: Padding(
          padding: EdgeInsets.fromLTRB(4, 6, 4, 6),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  colors: _getColorsByType(pokemon.types),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.white.withOpacity(0.15),
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: pokemon.imageUrl,
                        placeholder: (context, url) =>
                            _buildLoadingImagePokemon(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        height: 100,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pokemon.name,
                            overflow: TextOverflow.clip,
                            style: GoogleFonts.lato(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    '#${pokemon.descritibleId}',
                                    style: GoogleFonts.arsenal(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.6),
                                    ),
                                  )),
                              Row(
                                children: pokemon.types
                                    ?.map((type) => PokeTypes(type: type))
                                    ?.toList(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  List<Color> _getColorsByType(List<Map<String, dynamic>> types) {
    final colors =
        types.map((type) => Color(type['color']).withAlpha(100)).toList();
    if (colors.length == 1) {
      colors.add(colors[0]);
    }

    return colors;
  }

  Widget _buildLoadingImagePokemon() {
    return Image.asset('assets/images/pokeball.jpg');
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _homeBloc.dispatchOn<HomeEvent>(LoadMorePokemons(),
          key: _homeBloc.eventKey);
    }
  }

  @override
  void dispose() {
    _homeBloc?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }
}
