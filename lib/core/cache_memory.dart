import 'dart:collection';

class CacheMemory<T extends Comparable> extends SplayTreeSet<T> {
  CacheMemory() : super((current, next) => current.compareTo(next));
}
