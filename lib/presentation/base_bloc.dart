import 'dart:async';

import 'package:fancy_stream/fancy_stream.dart';

abstract class BaseBloc<Event> {
  final Fancy fancy;

  BaseBloc(this.fancy) {
    init();
  }

  void init() {
    listenOn<Event>(handleEvents);
  }

  void handleEvents(Event event);

  ///
  ///Delegation
  ///
  StreamSubscription<T> listenOn<T>(void Function(T) onData, {String key}) =>
      fancy.listenOn<T>(onData, key: key);

  void dispatchOn<T>(T value, {String key}) =>
      fancy.dispatchOn<T>(value, key: key);

  Stream<T> streamOf<T>({Object key}) => fancy.streamOf<T>(key: key);

  void dispose() => fancy.dispose();

  Map<String, dynamic> get map => fancy.map;
}
