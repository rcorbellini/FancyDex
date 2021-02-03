import 'dart:collection';

class SortedCacheMemory<T extends Comparable> extends SplayTreeSet<T> {
  SortedCacheMemory() : super((current, next) => current.compareTo(next));
}
