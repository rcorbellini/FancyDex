import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:fancy_dex/core/utils/constants.dart';
import 'package:fancy_dex/core/utils/network_status.dart';
import 'package:fancy_dex/core/utils/sorted_cache_memory.dart';
import 'package:fancy_dex/data/data_sources/pokemon_cache_data_source.dart';
import 'package:fancy_dex/data/data_sources/pokemon_remote_data_source.dart';
import 'package:fancy_dex/data/entities/pokemon_entity.dart';
import 'package:fancy_dex/data/repositories/pokemon_repository_imp.dart';
import 'package:fancy_dex/factory.dart';
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
import 'package:flutter_icons/flutter_icons.dart';

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
  bool filterOpen = false;

  @override
  void initState() {
    dispatchLoadingInitalPokemons();
    _scrollController.addListener(_onScroll);
    _homeBloc.listenOn<PokemonFound>(_whenPokemonFound,
        key: _homeBloc.pokemonFoundStatus);
    super.initState();
  }

  void dispatchLoadingInitalPokemons() {
    _homeBloc.dispatchOn<HomeEvent>(LoadMorePokemons(),
        key: _homeBloc.eventKey);
  }

  void _whenPokemonFound(PokemonFound pokemonFound) {
    if (pokemonFound?.pokemon == null) {
      return;
    }
    showDialog(
      context: context,
      builder: (_) => Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_buildPokemonItem(pokemonFound.pokemon)],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
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
                FontAwesome.filter,
                color: filterOpen ? Colors.blueGrey.shade100 : Colors.blueGrey,
              ),
              onPressed: () {
                setState(() {
                  filterOpen = !filterOpen;
                });
              })
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildRandomPokemon(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildFilterByNameOrId(),
          _filterByType(),
          Expanded(
              child: Stack(
            children: [
              _buildMainContent(),
              _buildSeparator(),
            ],
          ))
        ],
      ),
    );
  }

  Widget _buildSeparator() {
    return IgnorePointer(
        child: Container(
      height: 25,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white.withOpacity(0)]),
      ),
    ));
  }

  Widget _buildRandomPokemon() {
    return FloatingActionButton.extended(
        backgroundColor: Colors.white,
        elevation: 1,
        icon: Icon(
          FontAwesome.random,
          color: Colors.blueGrey,
        ),
        label: Text(
          'Random',
          style: GoogleFonts.lato(color: Colors.blueGrey, fontSize: 16),
        ),
        onPressed: () => _homeBloc.dispatchOn<HomeEvent>(RandomPokemon(),
            key: _homeBloc.eventKey));
  }

  Widget _buildFilterByNameOrId() {
    if (!filterOpen) {
      return Container();
    }

    final filterController = TextEditingController();

    return Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          height: 40,
          child: TextField(
            controller: filterController,
            style: TextStyle(fontSize: 16, height: 0.8),
            expands: false,
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffEAEBEC),
              hintText: 'Search for a Pokemon',
              hintStyle: TextStyle(
                fontSize: 16,
                height: 0.7,
                color: Colors.grey.shade400,
              ),
              prefixIcon: Icon(
                FontAwesome.search,
                color: Colors.grey.shade400,
                size: 15,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  FontAwesome.close,
                  color: Colors.grey.shade400,
                  size: 15,
                ),
                onPressed: () {
                  filterController.text = '';
                  _homeBloc.dispatchOn<HomeEvent>(LoadPokemonByNameOrId(''),
                      key: _homeBloc.eventKey);
                },
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade100),
                borderRadius: BorderRadius.circular(25.7),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade50),
                borderRadius: BorderRadius.circular(25.7),
              ),
            ),
            onChanged: (text) => _homeBloc.dispatchOn<HomeEvent>(
                LoadPokemonByNameOrId(text),
                key: _homeBloc.eventKey),
          ),
        ));
  }

  Widget _filterByType() {
    if (!filterOpen) {
      return Container();
    }
    return StreamBuilder(
      initialData: allTypeColors.keys,
      stream: _homeBloc.streamOf<List<String>>(
          key: _homeBloc.typesFilteredStatysKey),
      builder: (context, snapshot) {
        final selectedColors = snapshot.data;
        final widgets = allTypeColors
            .map((name, color) {
              final Map<String, dynamic> type = {'name': name, 'color': color};
              return MapEntry<String, Widget>(
                  name,
                  GestureDetector(
                    onTap: () => _homeBloc.dispatchOn<HomeEvent>(
                        LoadPokemonByType(name, selectedColors.toList()),
                        key: _homeBloc.eventKey),
                    child: PokeTypes(
                      type: type,
                      enable: selectedColors.contains(name),
                    ),
                  ));
            })
            .values
            .toList();
        return Padding(
            padding: EdgeInsets.all(6),
            child: Wrap(children: widgets.toList()));
      },
    );
  }

  Widget _buildMainContent() {
    return StreamBuilder(
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
    );
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
    return Center(
        child: Text(
      "Ops, couldn't load your pokemon.",
      style: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.red.shade300),
    ));
  }

  Widget _buildPokemonList(List<PokemonPresentation> pokemons) {
    final pokemonsVisible = pokemons.where((element) => element.visible);
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return _buildPokemonItem(pokemonsVisible.elementAt(index));
      },
      itemCount: pokemonsVisible.length,
      controller: _scrollController,
    );
  }

  Widget _buildPokemonItem(PokemonPresentation pokemon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => getDetailPage(pokemon),
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
                Stack(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(4),
                        child: CachedNetworkImage(
                          imageUrl: pokemon.imageUrl,
                          placeholder: (context, url) =>
                              _buildLoadingImagePokemon(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          height: 100,
                        )),
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: Colors.white.withOpacity(0.15),
                      child: ClipOval(child: Container()),
                    )
                  ],
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
        ),
      ),
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

  Widget getDetailPage(PokemonPresentation pokemon) => DetailPage(
        id: pokemon.id,
        detailBloc: newInstaceDetailBloc,
      );

  @override
  void dispose() {
    _homeBloc?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }
}
