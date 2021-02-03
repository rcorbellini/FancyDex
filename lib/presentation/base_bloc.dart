import 'package:fancy_stream/fancy_stream.dart';

abstract class BaseBloc<Event> extends FancyDelegate {

  BaseBloc(Fancy fancy) : super(fancy: fancy) {
    init();
  }

  void init() {
    listenOn<Event>(handleEvents);
  }

  void handleEvents(Event event);
}
