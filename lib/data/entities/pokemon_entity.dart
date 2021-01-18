import 'package:equatable/equatable.dart';

class PokemonEntity extends Equatable{
  int id;
  String name;
  String image;
  List types;
  num height;
  num weight;

  PokemonEntity({
   this.id,
    this.name,
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

}