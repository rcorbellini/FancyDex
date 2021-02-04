import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
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
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildFilterByName(),
        _buildMainContent(),
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

  Widget _buildFilterByName() {
    return TextField();
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

        return Column(
          children: [
            Expanded(child: _buildPokemonList(pokemons)),
            _buildLoading(loading),
          ],
        );
      },
    ));
  }

  Widget _buildLoading(bool loading) {
    if (loading) {
      return CircularProgressIndicator();
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: Color(0xff90C9A6),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white.withOpacity(0.15),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: pokemon.imageUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  height: 100,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '#${pokemon.id}',
                    style: GoogleFonts.arsenal(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.4)),
                  ),
                  Text(
                    pokemon.name,
                    style: GoogleFonts.lato(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
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

  @override
  void dispose() {
    _homeBloc?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }
}
