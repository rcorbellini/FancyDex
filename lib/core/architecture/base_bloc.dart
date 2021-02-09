import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:fancy_stream/fancy_stream.dart';

abstract class BaseBloc<Event> extends FancyDelegate {
  final eventKey = 'event';
  StreamSubscription _sbEvents;
  BaseBloc(Fancy fancy) : super(fancy: fancy) {
    init();
  }

  void init() {
    final stream = streamOf<Event>(key: eventKey) as ValueStream<Event>;
    _sbEvents =
        stream.debounceTime(Duration(milliseconds: 500)).listen(handleEvents);
  }

  @override
  void dispose() {
    super.dispose();
    _sbEvents?.cancel();
  }

  void handleEvents(Event event);
}
