import 'package:flutter/cupertino.dart';

class PokeLoading extends StatefulWidget {
  final double size;

  const PokeLoading({Key key, this.size = 50}) : super(key: key);

  @override
  _PokeLoadingState createState() => _PokeLoadingState();
}

///Loading with a pokeball doing a roll
class _PokeLoadingState extends State<PokeLoading>
    with SingleTickerProviderStateMixin {
  AnimationController _rotationController;
  //params
  double get size => widget.size;

  @override
  void initState() {
    _rotationController = AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _startAnnimationLoading();
    return RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_rotationController),
      child: Image.asset(
        'assets/images/pokeball.jpg',
        width: size,
      ),
    );
  }

  void _startAnnimationLoading() {
    _rotationController.repeat();
  }

  void _stopAnnimationLoading() {
    _rotationController.reset();
  }

  @override
  void dispose() {
    _stopAnnimationLoading();
    _rotationController?.dispose();
    super.dispose();
  }
}
