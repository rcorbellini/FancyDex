abstract class DetailEvent {}

class LoadById extends DetailEvent {
  final int id;

  LoadById(this.id);
}