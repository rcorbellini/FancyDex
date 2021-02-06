import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fancy_dex/presentation/detail/bloc/detail_bloc.dart';
import 'package:fancy_dex/presentation/detail/bloc/detail_event.dart';
import 'package:fancy_dex/presentation/detail/bloc/detail_status.dart';
import 'package:fancy_dex/presentation/models/pokemon_presentation.dart';
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

class _DetailPageState extends State<DetailPage> {
  DetailBloc get _bloc => widget.detailBloc;
  int get _id => widget.id;

  @override
  void initState() {
    dispatchLoadingInitalPokemon();
    super.initState();
  }

  void dispatchLoadingInitalPokemon() {
    _bloc.dispatchOn<DetailEvent>(LoadById(_id), key: _bloc.eventKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildMainContent(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Expanded(
        child: StreamBuilder(
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
                children: [
                  _buildDetailPokemon(pokemon),
                  _buildLoading(loading)
                ],
              );
            }));
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
          height: MediaQuery.of(context).size.height,
        ),
        painter: BackgroundPainter(Color(pokemon.primaryColor).withAlpha(100)),
      ),
      SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: texts(pokemon),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CachedNetworkImage(
                      imageUrl: pokemon.imageUrl,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      height: 230,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildDetail(pokemon),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    ]);
  }

  List<Widget> _buildDetail(PokemonPresentation pokemon) {
    return [
      Text(
        'Details',
        style: GoogleFonts.arsenal(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(pokemon.primaryColor).withAlpha(200)),
      ),
      Text('Height: ${pokemon.height} m'),
      Text('Weight: ${pokemon.weight} kg'),
    ];
  }

  @override
  void dispose() {
    _bloc?.dispose();
    super.dispose();
  }
}

List<Widget> texts(PokemonPresentation pokemon) {
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

class BackgroundPainter extends CustomPainter {
  final Color color;

  BackgroundPainter(this.color);
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = new Paint()..color = color;

    Path path = Path()
      ..relativeLineTo(0, 270)
      ..quadraticBezierTo(size.width / 2, 340.0, size.width, 270)
      ..relativeLineTo(0, -270)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
