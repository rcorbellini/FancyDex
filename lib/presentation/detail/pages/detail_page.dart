import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_dex/presentation/detail/bloc/detail_bloc.dart';
import 'package:fancy_dex/presentation/detail/bloc/detail_event.dart';
import 'package:fancy_dex/presentation/detail/bloc/detail_status.dart';
import 'package:fancy_dex/presentation/models/pokemon_presentation.dart';
import 'package:fancy_dex/presentation/widgets/poke_background.dart';
import 'package:fancy_dex/presentation/widgets/poke_bar_stats.dart';
import 'package:fancy_dex/presentation/widgets/poke_loading.dart';
import 'package:fancy_dex/presentation/widgets/poke_types.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatefulWidget {
  final DetailBloc detailBloc;
  final int id;

  const DetailPage({Key key, this.detailBloc, this.id}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage>
    with SingleTickerProviderStateMixin {
  DetailBloc get _bloc => widget.detailBloc;
  int get _id => widget.id;

  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    dispatchLoadingInitalPokemon();

    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 35, end: 100).animate(controller);
    controller.forward();

    super.initState();
  }

  void dispatchLoadingInitalPokemon() {
    _bloc.dispatchOn<DetailEvent>(LoadById(_id), key: _bloc.eventKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildMainContent(),
    );
  }

  PreferredSize _buildAppbar() {
    return PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
        child: StreamBuilder(
            initialData: PokemonLoading(),
            stream: _bloc.streamOf<DetailStatus>(key: _bloc.statusKey),
            builder: (context, snapshot) {
              final data = snapshot.data;
              final pokemon = data.pokemonLoaded;

              if (pokemon == null) {
                return Container();
              }

              return AppBar(
                backgroundColor: Color(pokemon.primaryColor).withAlpha(100),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back,
                      color: Colors.white.withOpacity(0.9)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                elevation: 0,
                centerTitle: false,
                title: Text(
                  "Detail",
                  style: GoogleFonts.bellota(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              );
            }));
  }

  Widget _buildMainContent() {
    return StreamBuilder(
        initialData: PokemonLoading(),
        stream: _bloc.streamOf<DetailStatus>(key: _bloc.statusKey),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final pokemon = data.pokemonLoaded;
          final loading = data is PokemonLoading;

          if (data is PokemonError) {
            return _buildError();
          }

          return Stack(
            children: [_buildDetailPokemon(pokemon), _buildLoading(loading)],
          );
        });
  }

  Widget _buildLoading(bool loading) {
    if (loading) {
      return Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: PokeLoading(
            size: 100,
          ),
        ),
      );
    }

    return Container();
  }

  Widget _buildError() {
    return Text('Erro aconteceu! tente novamente com internet.');
  }

  Widget _buildDetailPokemon(PokemonPresentation pokemon) {
    if (pokemon == null) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(pokemon),
        Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _buildInfoBody(pokemon),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(PokemonPresentation pokemon) {
    return Stack(alignment: Alignment.topLeft, children: [
      Positioned(
        top: -40,
        left: -60,
        child: Opacity(
          opacity: 0.04,
          child: RotatedBox(
              quarterTurns: 4,
              child: Image.asset('assets/images/pokeball.jpg', width: 300)),
        ),
      ),
      CustomPaint(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 290,
        ),
        painter: PokeBackground(Color(pokemon.primaryColor).withAlpha(100)),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _buildInfoHeaders(pokemon),
      ),
      Center(
        child: Padding(
          padding: EdgeInsets.only(left: 18),
          child: CachedNetworkImage(
            imageUrl: pokemon.imageUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            height: 230,
          ),
        ),
      ),
    ]);
  }

  List<Widget> _buildInfoHeaders(PokemonPresentation pokemon) {
    return [
      Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 8, 2),
        child: Text(
          '#${pokemon.descritibleId}',
          style: GoogleFonts.arsenal(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.6)),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(16, 2, 8, 2),
        child: Text(
          pokemon.name,
          style: GoogleFonts.lato(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(0.5, 0.5),
                blurRadius: 0.2,
                color: Colors.black.withOpacity(0.3),
              ),
              Shadow(
                offset: Offset(0.5, 0.5),
                blurRadius: 0.2,
                color: Colors.black.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(16, 2, 8, 2),
        child: Row(
          children: pokemon.types
              ?.map(
                (type) => PokeTypes(
                  type: type,
                  fontSize: 14,
                ),
              )
              ?.toList(),
        ),
      )
    ];
  }

  List<Widget> _buildInfoBody(PokemonPresentation pokemon) {
    return [
      Padding(
        padding: EdgeInsets.only(top: 26),
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About',
                  style: GoogleFonts.arsenal(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(pokemon.primaryColor).withAlpha(200),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Height: ',
                      style: GoogleFonts.rambla(
                          fontSize: 14, color: Colors.grey.shade500),
                    ),
                    Text(
                      '${pokemon.height} m',
                      style: GoogleFonts.rambla(
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'Weight: ',
                      style: GoogleFonts.rambla(
                          fontSize: 14, color: Colors.grey.shade500),
                    ),
                    Text(
                      '${pokemon.weight} kg',
                      style: GoogleFonts.rambla(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 18),
        child: Card(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stats',
                  style: GoogleFonts.arsenal(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(pokemon.primaryColor).withAlpha(200)),
                ),
                PokeBarStats(
                  stats: pokemon.statsToMap,
                  animation: animation,
                ),
              ],
            ),
          ),
        ),
      )
    ];
  }

  @override
  void dispose() {
    _bloc?.dispose();
    controller?.dispose();
    super.dispose();
  }
}
