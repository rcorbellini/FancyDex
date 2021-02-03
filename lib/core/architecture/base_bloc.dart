import 'package:fancy_stream/fancy_stream.dart';

abstract class BaseBloc<Event> extends FancyDelegate {
  final eventKey = 'event';
  BaseBloc(Fancy fancy) : super(fancy: fancy) {
    init();
  }

  void init() {
    listenOn<Event>(handleEvents, key: eventKey);
  }

  void handleEvents(Event event);
}
