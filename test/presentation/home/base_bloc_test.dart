import 'package:fancy_dex/core/architecture/base_bloc.dart';
import 'package:fancy_stream/fancy_stream.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FancyMock extends Mock implements Fancy {}

class DummyBloc extends BaseBloc {
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

    //act
    final homeBlocTest = DummyBloc(fancyMock);
    //assert
    verify(homeBlocTest.init());
  });

}
