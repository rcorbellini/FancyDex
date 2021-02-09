import 'package:fancy_dex/core/architecture/base_bloc.dart';
import 'package:fancy_dex/presentation/home/bloc/home_event.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class FancyMock extends Mock implements Fancy {}

class StreamMock<T> extends Mock implements ValueStream<T> {}

class DummyBloc extends BaseBloc<HomeEvent> {
  DummyBloc(Fancy fancy) : super(fancy);

  @override
  void handleEvents(event) {
    throw UnimplementedError();
  }
}

void main() {
  FancyMock fancyMock;

  setUp(() {
    fancyMock = FancyMock();
  });

  test('should listen event when created', () async {
    //arrange
    final stream = StreamMock<HomeEvent>();

    when(fancyMock.streamOf(key: anyNamed('key'))).thenAnswer((_) => stream);
    when(stream.transform(any)).thenAnswer((_) => stream);
    when(stream.listen(any)).thenAnswer((_) => null);

    //act
    final homeBlocTest = DummyBloc(fancyMock);
    //assert
    verify(fancyMock.streamOf(key: anyNamed('key')));
    verify(stream.listen(homeBlocTest.handleEvents));
  });
}
