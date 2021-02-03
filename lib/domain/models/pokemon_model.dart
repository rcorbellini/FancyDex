import 'package:equatable/equatable.dart';

class PokemonModel extends Equatable implements Comparable{
  final int id;
  final String name;
  final String image;
  final List types;
  final num height;
  final num weight;

  PokemonModel({
    this.id,
    this.name,
    this.image,
    this.types,
    this.height,
    this.weight,
  });

  @override
  List<Object> get props => [
        id,
        name,
        types,
        weight,
        height,
      ];

  @override
  int compareTo(other) {
     return  id - other.id;
  }
}
