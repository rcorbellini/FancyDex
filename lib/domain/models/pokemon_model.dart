import 'package:equatable/equatable.dart';

class PokemonModel extends Equatable implements Comparable {
  final int id;
  final String name;
  final String image;
  final List types;
  final List stats;
  final num height;
  final num weight;

  PokemonModel({
    this.id,
    this.name,
    this.image,
    this.types,
    this.height,
    this.weight,
    this.stats,
  });

  @override
  List<Object> get props => [id, name, types, weight, height, stats];

  @override
  int compareTo(other) {
    if(id == null || other?.id == null){
      return 0;
    }
    return id - other.id;
  }
}
